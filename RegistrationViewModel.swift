//
//  RegistrationViewModel.swift
//  Jobb
//
//  Created by Léonard Dinichert on 23.11.2023.
//

import Foundation

@MainActor
class RegistrationViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    /*
    @Published var isSignUpButtonIsEnabled: Bool {
        if password.isEmpty && password.count < 6 && email.isEmpty && !email.contains("@") && username.isEmpty {
            return false
        } else {
            return true
        }
    }
     */
    
    func createUser() async throws {
        try await JobbAuthService.shared.createUser(email: email, password: password, username: username)
        print(username)
        print(password)
        print(email)
        
        username = ""
        password = ""
        email = ""
    }
}
