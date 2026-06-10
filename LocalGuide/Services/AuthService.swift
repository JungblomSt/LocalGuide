//
//  AuthService.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-26.
//

import FirebaseAuth
import Observation

@Observable
final class AuthService {
    var currentUser: User?
    
    init(){
        currentUser = Auth.auth().currentUser
        _ = Auth.auth().addStateDidChangeListener { _, user in
            self.currentUser = user
        }
    }
    
      var isSignedIn: Bool {
        currentUser != nil
    }
    
    
    func signIn(email: String, password: String) async throws  {
         try await Auth.auth().signIn(withEmail: email, password: password)
       
    }
    
    func signUp(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user.uid
    }
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func reauthenticate(password: String) async throws {
        guard let user = currentUser,
              let email = user.email else { return }
        
        let credential = EmailAuthProvider.credential(
            withEmail: email,
            password: password
        )
        
        _ = try await user.reauthenticate(with: credential)
    }
    
    func deleteAccount() async throws {
        try await currentUser?.delete()
    }
}
