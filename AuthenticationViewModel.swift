//
//  AuthenticationViewModel.swift
//  Jobb
//
//  Created by Léonard Dinichert on 12.11.2023.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    
    private let service = JobbAuthService.shared
    private var canellables = Set<AnyCancellable>()
        
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        service.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &canellables)
        
        service.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &canellables)
    }
}

struct User: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullname: String?
    let email: String
    
    var iscurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
}
