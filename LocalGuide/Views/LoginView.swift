//
//  Login.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-26.
//


import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel
    private let auth: AuthService
    private let userRepository: UserRepository

    init(auth: AuthService, userRepository: UserRepository) {
        self.auth = auth
        self.userRepository = userRepository
        _viewModel = State(initialValue: LoginViewModel(auth: auth))
    }

    var body: some View {
        NavigationStack {
            Form {
                emailInput
                passwordInput
                signInButton
                registerLink
            }
            .navigationTitle("Logga in")
            .navigationBarTitleDisplayMode(.inline)
        }
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
                .textContentType(.password)
            if let error = viewModel.passwordError {
                Text(error).foregroundStyle(.red).font(.caption)
            }
        } header: {
            Text("Lösenord")
        }
    }



    private var signInButton: some View {
        Section {
            Button {
                if viewModel.validate() {
                    Task { await viewModel.signIn() }
                }
            } label: {
                HStack {
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Logga in")
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

   

    private var registerLink: some View {
        Section {
            NavigationLink("Har du inget konto? Skapa ett") {
                RegisterView(auth: auth, userRepository: userRepository)
            }
        }
    }
}
