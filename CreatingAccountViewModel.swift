//
//  EmailViewModel.swift
//  TOD
//
//  Created by Léonard Dinichert on 10.07.23.
//

import Foundation
    
final class CreateUserAccount: ObservableObject {
    
    @Published var name : String = ""
    @Published var username : String = ""
    @Published var age: String = ""
    
   /* func AddName() async throws {
        guard !name.isEmpty else {
            print("error")
            return
        }
        let authDataResult = try await authenticationManager.shared.createUser()
        try await UserManager.shared.createNewUser(auth: authDataResult)
    } */
    
}
