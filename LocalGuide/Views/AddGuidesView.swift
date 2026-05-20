//
//  AddGuideView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-14.
//

import SwiftUI



struct AddGuidesView: View {
    
    @State private var viewModel = AddGuideViewModel()
    @State private var showPublishedAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Form {
                    titleInput
                    cityInput
//                    locationSelection
                    categorySelection
//                    audioSelection
//                    imageSelection
                    descriptionInput
                    uploadButton
                }
                .navigationTitle(Text("Dela en guidning"))
                .navigationBarTitleDisplayMode(.inline)
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
                Text("\(viewModel.title) har lagts till på kartan.") // TODO: visa hur guiden ser ut antingen i listan eller när man klickat på pinnen
            }
        }
    }
}

#Preview {
    AddGuidesView()
}

