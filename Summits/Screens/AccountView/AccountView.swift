import SwiftUI
import SwiftData
import UIKit
import ZIPFoundation
import CoreXLSX

struct AccountView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var hikes: [Hike]
    
    @State private var summits: [Summit] = []
    @State var confirmResetVisible = false
    @State private var exportURL: URL?
    @State private var isExporting = false
    @State private var isExportSheetVisible = false
    @State private var showExportError = false
    @State private var exportErrorMessage = ""
    
    func loadSummits() {
        do {
            let summits = try getSummits()
            self.summits = summits
        } catch {
            print(error)
        }
    }
    
    func resetData() {
        confirmResetVisible = false
        do {
            try modelContext.delete(model: Hike.self)
        } catch {
            print("Failed to reset Hike data.")
        }
    }
    
    func getSummitName(for summitID: String) -> String {
        if let summit = summits.first(where: { $0.id == summitID }) {
            return summit.name
        }
        return "Unknown-Summit"
    }
    
    func formatDateForFilename(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func exportHikes() {
        isExporting = true
        DispatchQueue.global(qos: .userInitiated).async {
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                  let templatePath = Bundle.main.url(forResource: "WM4_app", withExtension: "csv") else {
                DispatchQueue.main.async {
                    self.isExporting = false
                    self.exportErrorMessage = "Failed to locate export template"
                    self.showExportError = true
                }
                return
            }
            
            let exportPath = documentsPath.appendingPathComponent("WM4_app_filled.csv")
            
            do {
                if FileManager.default.fileExists(atPath: exportPath.path) {
                    try FileManager.default.removeItem(at: exportPath)
                }
                
                try FileManager.default.copyItem(at: templatePath, to: exportPath)
                
                let csvContent = try String(contentsOf: exportPath, encoding: .utf8)
                var csvLines = csvContent.components(separatedBy: .newlines)
                
                let hikesBySummit = Dictionary(grouping: hikes, by: { $0.summitID })
                
                for (index, line) in csvLines.enumerated() {
                    let components = line.components(separatedBy: ",")
                    guard components.count >= 2 else { continue }
                    
                    let mountainName = components[0]
                    
                    let elevation = components.count > 1 ? components[2] : ""
                    
                    if let summit = summits.first(where: { $0.officialName == mountainName }),
                       let latestHike = hikesBySummit[summit.id]?.sorted(by: { $0.date > $1.date }).first {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        let dateString = dateFormatter.string(from: latestHike.date)
                        
                        let comments = """
                            \(latestHike.weather.isEmpty ? "\(latestHike.weather)." : "")
                            \(!latestHike.companions.isEmpty ? "Companions: \(latestHike.companions). " : "")
                            \(latestHike.details.isEmpty ? "\(latestHike.details)." : "")
                            Rated: \(latestHike.rating)/5
                            """.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                        let escapedComments = comments.replacingOccurrences(of: "\"", with: "\"\"")
                        
                        // Double commas are unused columns in the original spreadsheet
                        csvLines[index] = "\(mountainName),,\(elevation),\(dateString),,\"\(escapedComments)\"".trimmingCharacters(in: .whitespaces)
                    }
                }
                
                let updatedContent = csvLines.filter { !$0.isEmpty }.joined(separator: "\r\n")
                try updatedContent.write(to: exportPath, atomically: true, encoding: .utf8)
                
                DispatchQueue.main.async {
                    self.exportURL = exportPath
                    self.isExporting = false
                    self.isExportSheetVisible = true
                }
            } catch {
                print("Export failed: \(error)")
                DispatchQueue.main.async {
                    self.isExporting = false
                    self.exportErrorMessage = "Failed to export: \(error.localizedDescription)"
                    self.showExportError = true
                }
            }
        }
    }
    
    func zipFiles(fileURLs: [URL], zipFileURL: URL) -> Bool {
        do {
            let archive = try Archive(url: zipFileURL, accessMode: .create)
            
            for fileURL in fileURLs {
                try archive.addEntry(with: fileURL.lastPathComponent, relativeTo: fileURL.deletingLastPathComponent())
            }
            
            return true
        } catch {
            print("Failed to create ZIP: \(error)")
            return false
        }
    }
    
    var body: some View {
        Form {
            Section {
                Label("A summit hiking log for tracking hikes of the New Hampshire 4000 foot mountains", systemImage: "mountain.2.circle")
                Label("Developed by Nick Schaefer", systemImage: "person.fill")
                Link(destination: URL(string: "https://www.nschaefer.com/")!, label: {
                    Label("www.nschaefer.com", systemImage: "globe")
                })
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/naturalnick/Summits/blob/main/Privacy%20Policy")!, label: {
                    Label("Privacy Policy", systemImage: "lock.circle")
                })
                ShareLink("Share App", item: URL(string: "https://apps.apple.com/us/app/white-mountain-4000ft-tracker/id6476589208")!)
            }
            
            Section {
                Button {
                    exportHikes()
                } label: {
                    if isExporting {
                        HStack {
                            Text("Preparing Export...")
                            Spacer()
                            ProgressView()
                        }
                    } else {
                        Text("Export Hiking Data")
                    }
                }
                .disabled(isExporting)
                
                Button(role: .destructive, action: {
                    confirmResetVisible = true
                }, label: {
                    Text("Clear Hike Data")
                })
            } header: {
                Text("Actions")
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog("Confirm Clear Hike Data", isPresented: $confirmResetVisible, titleVisibility: .visible) {
            Button(role: .destructive, action: {
                resetData()
            }, label: {
                Text("Clear Data")
            })
        } message: {
            Text("This action cannot be undone.")
        }
        .onAppear{
            loadSummits()
        }
        .confirmationDialog("Confirm Export", isPresented: $isExportSheetVisible) {
            if let exportURL = exportURL {
                ShareLink(item: exportURL) {
                    Text("Confirm Export")
                }
            }
        }
        .alert("Export Error", isPresented: $showExportError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(exportErrorMessage)
        }
    }
}

#Preview {
    NavigationStack {
        AccountView()
    }
}
