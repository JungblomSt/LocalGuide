//
//  AddGuideView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-14.
//

import SwiftUI
import MapKit

struct AddGuidesView: View {

    @State private var viewModel = AddGuideViewModel()
    @State private var showPublishedAlert: Bool = false
    @State private var showMapPicker: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    titleInput
                    cityInput
                    locationSelection
                    categorySelection
                    descriptionInput
                    uploadButton
                }
                .navigationTitle(Text("Dela en guidning"))
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showMapPicker) {
                    MapLocationPickerView(selectedLocation: $viewModel.tempLocation)
                }
            }
        }
    }

    // MARK: Titel

    private var titleInput: some View {
        Section {
            TextField("Vad heter/kallas den här platsen?", text: $viewModel.title)
            if let error = viewModel.titleError {
                Text(error)
                    .foregroundStyle(Color.red)
            }
        } header: {
            Text("Titel")
        }
    }

    // MARK: Stad

    private var cityInput: some View {
        Section {
            TextField("Vilken stad ligger platsen i?", text: $viewModel.city)
            if let error = viewModel.titleError {
                Text(error)
                    .foregroundStyle(Color.red)
            }
        } header: {
            Text("Stad")
        }
    }

    // MARK: Plats

    private var locationSelection: some View {
        Section {
            HStack(spacing: 12) {
                Button {
                    viewModel.useCurrentLocation()
                } label: {
                    Label("Nuvarande plats", systemImage: "location.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    showMapPicker = true
                } label: {
                    Label("Välj på karta", systemImage: "map.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            if let location = viewModel.tempLocation {
                Text(String(format: "Lat: %.5f, Lon: %.5f", location.latitude, location.longitude))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let error = viewModel.locationError {
                Text(error)
                    .foregroundStyle(Color.red)
            }
        } header: {
            Text("Plats")
        }
    }

    // MARK: Kategori

    private var categorySelection: some View {
        Section {
            Picker("Kategori:", selection: $viewModel.category) {
                ForEach(Category.allCases) { category in
                    Text(category.displayName).tag(category)
                }
            }
            .pickerStyle(.automatic)
        }
    }

    // MARK: Beskrivning

    private var descriptionInput: some View {
        Section {
            TextField(
                "Beskriv platsen kort",
                text: $viewModel.description,
                axis: .vertical
            )
            .lineLimit(3...6)

            if let error = viewModel.descriptionError {
                Text(error)
                    .foregroundStyle(Color.red)
            }
        } header: {
            Text("Beskrivning")
        }
    }

    // MARK: Knapp

    private var uploadButton: some View {
        Section {
            Button {
                if viewModel.validate() {
                    viewModel.saveGuide()
                    viewModel.reset()
                    showPublishedAlert = true
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Publisera")
                    Spacer()
                }
            }
            .alert("Guide publicerad! ", isPresented: $showPublishedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("\(viewModel.title) har lagts till på kartan.")
            }
        }
    }
}

// MARK: - Map picker

struct MapLocationPickerView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Environment(\.dismiss) private var dismiss

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 59.0, longitude: 16.0),
            span: MKCoordinateSpan(latitudeDelta: 9, longitudeDelta: 9)
        )
    )
    @State private var pin: CLLocationCoordinate2D?

    var body: some View {
        NavigationStack {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    if let pin {
                        Marker("Vald plats", coordinate: pin)
                    }
                }
                .onTapGesture { screenPoint in
                    if let coordinate = proxy.convert(screenPoint, from: .local) {
                        pin = coordinate
                    }
                }
            }
            .navigationTitle("Välj plats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Klar") {
                        selectedLocation = pin
                        dismiss()
                    }
                    .disabled(pin == nil)
                }
            }
        }
    }
}

#Preview {
    AddGuidesView()
}

