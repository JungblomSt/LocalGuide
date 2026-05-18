//
//  AddGuideView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-14.
//

import SwiftUI



struct AddGuidesView: View {
    
    @State private var viewModel = AddGuideViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack{
                Form {
                    titleInput
//                    locationSelection
//                    categorySelection
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
        } header: {
            Text("Titel")
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
        } header: {
            Text("Beskrivning")
        }
    }
    
    // MARK: Knapp
    
    private var uploadButton: some View {
        Section {
            Button {
                viewModel.saveGuide()
            } label: {
                HStack {
                    Spacer()
                    Text("Publisera")
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AddGuidesView()
}

