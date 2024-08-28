//
//  SummitLogView.swift
//  Summits
//
//  Created by Nick on 10/8/23.
//

import SwiftUI
import SwiftData
import PhotosUI

enum FormTextField {
    case weather, companions, details
}

struct HikeLogView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var viewModel = HikeLogViewModel()
    
    let summit: Summit
    var currentHike: Hike
    @Binding var hikeLogVisible: Bool
    
    @FocusState private var focusedField: FormTextField?
    
    func deleteHike() {
        viewModel.deleteAlertVisible = false
        hikeLogVisible = false
        modelContext.delete(currentHike)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Summit Date", selection: $viewModel.selectedDate, in: viewModel.dateRange, displayedComponents: .date)
                    .onChange(of: viewModel.selectedDate) { oldDate, newDate in
                        currentHike.date = newDate
                    }
                
                Section {
                    HStack {
                        Text("Rating")
                        Spacer()
                        Rating(rating: $viewModel.rating, disabled: false)
                            .onChange(of: viewModel.rating) { oldRating, newRating in
                                currentHike.rating = newRating
                            }
                    }
                }
                
                Section {
                    ImagePicker(images: $viewModel.images)
                }
                .onChange(of: viewModel.images) { oldImages, newImages in
                    currentHike.images = newImages
                }
                
                Section {
                    TextField("Sunny, Cloudy, etc.", text: $viewModel.weather)
                        .focused($focusedField, equals: .weather)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .companions
                        }
                } header: {
                    Text("Weather")
                }
                .onChange(of: viewModel.weather) { oldWeather, newWeather in
                    currentHike.weather = newWeather
                }
                
                Section {
                    TextField("Brother, sister, etc", text: $viewModel.companions)
                        .focused($focusedField, equals: .companions)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .details
                        }
                } header: {
                    Text("Companions")
                }
                .onChange(of: viewModel.companions) { oldCompanions, newCompanions in
                    currentHike.companions = newCompanions
                }
                
                Section {
                    TextField("Trail names, mileage, trail conditions, etc", text: $viewModel.details, axis: .vertical)
                        .lineLimit(10, reservesSpace: true)
                        .focused($focusedField, equals: .weather)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                } header: {
                    Text("Details")
                }
                .onChange(of: viewModel.details) { oldDetails, newDetails in
                    currentHike.details = newDetails
                }
                
                Button {
                    viewModel.deleteAlertVisible = true
                } label: {
                    Text("Delete Hike")
                        .foregroundStyle(.red)
                }
                
            }
            .navigationTitle("I Hiked Mt \(summit.name)")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !currentHike.saved {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            hikeLogVisible = false
                            
                            if !currentHike.saved {
                                modelContext.delete(currentHike)
                            }
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        currentHike.saved = true
                        hikeLogVisible = false
                    } label: {
                        Text(currentHike.saved ? "Done" : "Save")
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.selectedDate = currentHike.date
            viewModel.rating = currentHike.rating
            viewModel.weather = currentHike.weather
            viewModel.companions = currentHike.companions
            viewModel.details = currentHike.details
            viewModel.images = currentHike.images
        })
        .interactiveDismissDisabled(!currentHike.saved)
        .confirmationDialog("Confirm Delete Hike", isPresented: $viewModel.deleteAlertVisible, titleVisibility: .visible) {
            Button(role: .destructive, action: {
                deleteHike()
            }, label: {
                Text("Delete")
            })
        } message: {
           Text("This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        Text("")
            .sheet(
                isPresented: .constant(true)) {
                    HikeLogView(
                        viewModel: HikeLogViewModel(),
                        summit: .washington,
                        currentHike: Hike(
                            summitID: "0",
                            date: Date(),
                            rating: 5,
                            weather: "Sunny",
                            companions: "",
                            details: "Details",
                            images: []
                        ),
                        hikeLogVisible: .constant(true)
                    )
                    .presentationDetents([.large])
            }
    }
    .modelContainer(for: Hike.self)
}
