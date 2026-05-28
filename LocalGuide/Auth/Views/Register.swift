//
//  Register.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-26.
//



import SwiftUI

struct RegisterView: View {
    @State private var viewModel: RegisterViewModel

    init(auth: AuthService, userRepository: UserRepository) {
        _viewModel = State(initialValue: RegisterViewModel(auth: auth, userRepository: userRepository))
    }

    var body: some View {
        Form {
            emailInput
            passwordInput
            displayNameInput
            signUpButton
        }
        .navigationTitle("Skapa konto")
        .navigationBarTitleDisplayMode(.inline)
    }

 

    private var emailInput: some View {
        Section {
            TextField("E-post", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
            if let error = viewModel.emailError {
                Text(error).foregroundStyle(.red).font(.caption)
            }
        } header: {
            Text("E-post")
        }
    }

   

    private var passwordInput: some View {
        Section {
            SecureField("Lösenord", text: $viewModel.password)
                .textContentType(.newPassword)
            if let error = viewModel.passwordError {
                Text(error).foregroundStyle(.red).font(.caption)
            }
        } header: {
            Text("Lösenord (minst 6 tecken)")
        }
    }

   

    private var displayNameInput: some View {
        Section {
            TextField("Visningsnamn", text: $viewModel.displayName)
                .textContentType(.name)
            if let error = viewModel.displayNameError {
                Text(error).foregroundStyle(.red).font(.caption)
            }
        } header: {
            Text("Namn")
        }
    }

   

    private var signUpButton: some View {
        Section {
            Button {
                if viewModel.validate() {
                    Task { await viewModel.signUp() }
                }
            } label: {
                HStack {
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Skapa konto")
                    }
                    Spacer()
                }
            }
            .disabled(viewModel.isLoading)

            if let error = viewModel.errorMessage {
                Text(error).foregroundStyle(.red).font(.caption)
            }
        }
    }
}

 
