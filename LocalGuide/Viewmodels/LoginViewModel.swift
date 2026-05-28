//
//  LoginViewModel.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-26.
//

import Foundation
import Observation

@Observable
final class LoginViewModel{
    var email = ""
    var password = ""
    
    var emailError: String?
    var passwordError: String?
    var errorMessage: String?
    var isLoading = false
    
    private let auth : AuthService
    
    init(auth: AuthService){
        self.auth = auth
    }
    
    var isValid: Bool {
        emailError == nil && passwordError == nil
    }
    
    func validate() -> Bool{
        emailError = email.contains("@") && email.contains(".") ? nil : "* Ange en giltig e-postadress."
        passwordError = password.count >= 6 ? nil : "* Lösenord måste vara minst 6 tecken långt."
        return isValid
    }
    
    func signIn() async {
        isLoading = true
        errorMessage = nil
        
        defer{isLoading = false}
        do{
            try await auth.signIn(email: email, password: password)
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func reset(){
        email = ""
        password = ""
        emailError = nil
        passwordError = nil
        errorMessage = nil
    }
}
