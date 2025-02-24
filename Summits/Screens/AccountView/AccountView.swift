import SwiftUI
import SwiftData
import UIKit
import ZIPFoundation

struct AccountView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var hikes: [Hike]
    
    @State private var summits: [Summit] = []
    @State var confirmResetVisible = false
    @State private var exportURL: URL?
    @State private var isExporting = false
    @State private var isExportSheetVisible = false
    
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
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                DispatchQueue.main.async {
                    isExporting = false
                }
                return
            }
            
            let exportFolder = documentsPath.appendingPathComponent("HikeExport", isDirectory: true)
            
            try? FileManager.default.createDirectory(at: exportFolder, withIntermediateDirectories: true, attributes: nil)
            
            let textFileURL = exportFolder.appendingPathComponent("hikes_export.txt")
            
            var exportText = "Summits Hiking Log\n\n"
            
            var fileURLs = [textFileURL]
            
            for hike in hikes {
                let summitName = getSummitName(for: hike.summitID)
                let dateStr = formatDateForFilename(date: hike.date)
                
                exportText += """
            Summit: \(summitName)
            Date: \(dateStr)
            Rating: \(hike.rating)
            Weather: \(hike.weather)
            Companions: \(hike.companions)
            Details: \(hike.details)
            Images: \(!hike.images.isEmpty ? "\(hike.images.count) attached" : "None")
            """
                
                for (index, imageData) in hike.images.enumerated() {
                    // Create a filename with summit name and date
                    let imageFileName = "\(summitName)_\(dateStr)\(index != 0 ? "_\(index + 1)" : "").jpg"
                        .replacingOccurrences(of: " ", with: "-") // Replace spaces with hyphens
                        .replacingOccurrences(of: "/", with: "-") // Replace slashes
                    
                    let imageFileURL = exportFolder.appendingPathComponent(imageFileName)
                    
                    do {
                        try imageData.write(to: imageFileURL)
                        fileURLs.append(imageFileURL)
                    } catch {
                        print("Failed to save image: \(error)")
                    }
                }
            }
            
            do {
                try exportText.write(to: textFileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed to write text file: \(error)")
                return
            }
            
            let zipFileURL = documentsPath.appendingPathComponent("HikeExport.zip")
            
            try? FileManager.default.removeItem(at: zipFileURL)
            
            if zipFiles(fileURLs: fileURLs, zipFileURL: zipFileURL) {
                DispatchQueue.main.async {
                    self.exportURL = zipFileURL
                    self.isExporting = false
                    isExportSheetVisible = true
                }
            } else {
                DispatchQueue.main.async {
                    self.isExporting = false
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
    }
}

#Preview {
    NavigationStack {
        AccountView()
    }
}
