//
//  LoginViewModel.swift
//  Jobb
//
//  Created by Léonard Dinichert on 23.11.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        try await JobbAuthService.shared.logIn(withEmail: email, password: password)
    }
}
