//
//  RegisterViewModel.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-26.
//

import Foundation
import Observation


@Observable
final class RegisterViewModel{
    
var email = ""
var password = ""
var displayName = ""
    
    
var emailError: String?
var passwordError: String?
var displayNameError: String?
var errorMessage: String?
var isLoading = false
    
private let auth: AuthService
private let userRepository: UserRepository
    
    
    init(auth: AuthService, userRepository: UserRepository){
        self.auth = auth
        self.userRepository = userRepository
    }
    
    var isValidated: Bool {
        emailError == nil && passwordError == nil && displayNameError == nil
    }
    
    
    func validate() -> Bool {
        emailError = email.contains("@") && email.contains(".") ? nil : "* Ange en giltig e-postadress."
        passwordError = password.count >= 6 ? nil : "* Lösenord måste vara minst 6 tecken långt."
        displayNameError = displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "* Användarnamn kan inte vara tomt." : nil
        return isValidated
    }
    
    func signUp() async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        do {
            let uid = try await auth.signUp(email: email, password: password)
            let profile = UserProfile(
                id : uid,
                email : email,
                displayName : displayName.trimmingCharacters(in: .whitespaces),
                bio: nil ,
                photoURL: nil ,
                createdAt: Date(),
            )
            try await userRepository.createProfile(profile)
        }catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func reset(){
        email = ""
        password = ""
        displayName = ""
        emailError = nil
        passwordError = nil
        displayNameError = nil
        errorMessage = nil
    }
}
