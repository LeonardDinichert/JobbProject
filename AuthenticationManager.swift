//
//  AuthenticationManager.swift
//  TOD
//
//  Created by Léonard Dinichert on 06.07.23
//

/*struct AuthDataResultModel {
 
 let uid: String
 let email: String?
 let photoUrl: String?
 
 init(user: User) {
 
 self.uid = user.uid
 self.email = user.email
 self.photoUrl = user.photoURL?.absoluteString
 }
 }
 
 enum authProviderOption: String {
 
 case email = "password"
 case google = "google.com"
 }
 
 final class authenticationManager {
 
 static let shared = authenticationManager()
 private init () {}
 
 func getAuthenticatedUser() throws -> AuthDataResultModel {
 guard let user = Auth.auth().currentUser else {
 throw URLError(.badServerResponse )
 }
 
 return AuthDataResultModel(user: user)
 }
 
 func getProviders() throws -> [authProviderOption] {
 guard let providerData = Auth.auth().currentUser?.providerData else {
 throw URLError(.badServerResponse)
 }
 var providers: [authProviderOption] = []
 for provider in providerData {
 if let option = authProviderOption(rawValue: provider.providerID) {
 providers.append(option)
 
 } else {
 assertionFailure("Provider option not found \(provider.providerID)")
 
 }
 }
 
 return providers
 }
 
 func signOut() throws {
 try Auth.auth().signOut()
 }
 
 func deleteAccount() async throws {
 guard let user = Auth.auth().currentUser else {
 throw URLError(.badURL)
 }
 try await user.delete()
 }
 }
 
 // MARK SIGN IN EMAIL
 extension authenticationManager {
 
 @discardableResult
 func createUser(email: String, password: String) async throws -> AuthDataResultModel {
 let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
 return AuthDataResultModel(user: authDataResult.user)
 }
 
 @discardableResult
 func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
 let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
 return AuthDataResultModel(user: authDataResult.user)
 
 }
 
 func resetPassword(email: String) async throws {
 try await Auth.auth().sendPasswordReset(withEmail: email)
 }
 
 func updatePassword(password: String) async throws {
 guard let user =  Auth.auth().currentUser else {
 throw URLError(.badServerResponse)
 }
 
 try await user.updateEmail(to: password)
 }
 
 func updateEmail(email: String) async throws {
 guard let user =  Auth.auth().currentUser else {
 throw URLError(.badServerResponse)
 }
 
 try await user.updatePassword(to: email)
 }
 }
 
 // MARK : SIGN IN SSO
 extension authenticationManager {
 
 @discardableResult
 func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel{
 
 let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
 return try await signIn(credential: credential)
 }
 
 func signIn(credential: AuthCredential) async throws -> AuthDataResultModel{
 
 let authDataResult = try await Auth.auth().signIn(with: credential)
 return AuthDataResultModel(user: authDataResult.user)
 }
 }
 */

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

class JobbAuthService {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = JobbAuthService()
    
    init() {
        Task { try await loadUserData() }
    }
    
    @MainActor
    func logIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(email: String, password: String, username: String) async throws{
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user
        await uploadUserData(uid: result.user.uid, username: username, email: email)
        print(username)
        print(password)
        print(email)
    }
    
    @MainActor
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else { return }
        self.currentUser = try await UserService.fetchUser(withUid: currentUid)
        //                let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
        //                self.currentUser = try? snapshot.data(as: User.self)
    }
    
    @MainActor
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    // Forgot password func
    @MainActor
    static func resetPassword(email: String, resetCompletion:@escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                resetCompletion(.failure(error))
            } else {
                resetCompletion(.success(true))
            }
        }
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
        self.currentUser = user
        
        // Encode user data and set it in Firestore
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        do {
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("DEBUG: Error uploading user data: \(error.localizedDescription)")
            // Handle error as needed
        }
    }
}

struct UserService {
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchAllUsers() async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
    }
}
