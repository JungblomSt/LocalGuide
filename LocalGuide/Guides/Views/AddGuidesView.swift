//
//  AddGuideView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-14.
//

import SwiftUI
import MapKit
import PhotosUI

struct AddGuidesView: View {

    @State private var viewModel: AddGuideViewModel
    
    init(auth: AuthService) {
        _viewModel = State(
            initialValue: AddGuideViewModel(auth: auth)
        )
    }
    
    @State private var showPublishedAlert: Bool = false
    @State private var showMapPicker: Bool = false
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var tempImage: UIImage? = nil
    @State private var isLoadingImage: Bool = false
    
    @State private var showCamera: Bool = false
    @State private var capturedImage: UIImage?

    @State private var selectedAudioURL: URL? = nil
    @State private var showAudioPicker: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    titleInput
                    cityInput
                    locationSelection
                    categorySelection
                    imagePicker
                    audioPicker
                    descriptionInput
                    uploadButton
                    
                }
                .scrollDismissesKeyboard(.interactively)

                .navigationTitle(Text("Dela en guidning"))
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showMapPicker) {
                    MapLocationPickerView(selectedLocation: $viewModel.tempLocation)
                }
                .sheet(isPresented: $showCamera) {
                    CameraPicker { image in
                        capturedImage = image
                        Task { await viewModel.uploadImage(image) }
                    }
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
            if let error = viewModel.cityError {
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
    
    // MARK: Bild
    
    private var imagePicker: some View {
        Section {
            HStack(spacing: 12) {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Label("Välj en bild", systemImage: "folder.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    showCamera = true
                } label: {
                    Label("Ta ett foto", systemImage: "camera")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            // Visa vald bild (från galleri ELLER kamera)
            if let image = tempImage ?? capturedImage {
                VStack(alignment: .leading, spacing: 8) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Button(role: .destructive) {
                        tempImage = nil
                        selectedItem = nil
                        capturedImage = nil
                    } label: {
                        Label("Ta bort bild", systemImage: "trash")
                            .font(.caption)
                    }
                }
            } else if isLoadingImage {
                HStack {
                    ProgressView()
                    Text("Laddar bild...")
                        .foregroundStyle(.secondary)
                }
            }

            if viewModel.isUploadingImage {
                ProgressView("Laddar upp bild…")
            }
        } header: {
            Text("Bild")
        }
    }

    // MARK: Ljud

    private var audioPicker: some View {
        Section {
            Button {
                showAudioPicker = true
            } label: {
                HStack {
                    Image(systemName: "folder.fill")
                    Text("Välj en ljudfil")
                }
                .frame(maxWidth: .infinity)
            }

            if let url = selectedAudioURL {
                HStack {
                    Image(systemName: "waveform")
                    Text(url.lastPathComponent)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button(role: .destructive) {
                        selectedAudioURL = nil
                    } label: {
                        Image(systemName: "trash")
                            .font(.caption)
                    }
                }
            }
        } header: {
            Text("Ljud")
        }
        .fileImporter(
            isPresented: $showAudioPicker,
            allowedContentTypes: [.audio, .mp3],
            allowsMultipleSelection: false
        ) { result in
            if let url = try? result.get().first {
                selectedAudioURL = url
            }
        }
    }
    // MARK: Recording
    // button to open .sheet for recording
    
    //info view showing recording
    // time of current record
    
    // stop, continy, reset buttons
    
    //button to add selected recording to upload.
    
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
                Task {
                    if viewModel.validate() {

                        if let image = tempImage {
                            await viewModel.uploadImage(image)
                        }

                        if let audioURL = selectedAudioURL {
                            await viewModel.uploadAudio(audioURL)
                        }

                        // Spara guiden
                        try await viewModel.saveGuide()
                        viewModel.reset()
                        tempImage = nil
                        selectedItem = nil
                        selectedAudioURL = nil
                        capturedImage = nil
                        showPublishedAlert = true
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    if viewModel.isUploadingImage || viewModel.isUploadingAudio {
                        ProgressView()
                            .progressViewStyle(.circular)
                        Text("Publicerar...")
                    } else {
                        Text("Publisera")
                    }
                    Spacer()
                }
            }
            .disabled(viewModel.isUploadingImage || viewModel.isUploadingAudio)
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let newValue {
                    isLoadingImage = true
                    // Ladda bilden för preview
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        tempImage = image
                    }
                    isLoadingImage = false
                }
            }
        }
        .alert("Guide publicerad! ", isPresented: $showPublishedAlert) {
            Button("OK", role: .cancel) { }
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
    AddGuidesView(auth: AuthService())
}

