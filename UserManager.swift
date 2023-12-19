//
//  userManager.swift
//  Jobb
//
//  Created by Léonard Dinichert on 10.07.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    
    let userId: String
    let email: String?
    let profileImageUrl: String?
    let dateCreated: Date?
    let age: Int?
    let username: String?
    let isJobber: Bool?
    let preferences: [String]?
    let firstName: String?
    let lastName: String?
    let profession: String?
    
    
    init(auth: User) {
        self.init(
            userId: auth.id,
            email: auth.email,
            profileImageUrl: auth.profileImageUrl,
            dateCreated: Date(),
            age: nil,
            username: nil,
            isJobber: false,
            preferences: nil,
            firstName: nil,
            lastName: nil,
            profession : nil
            
        )
    }

    init(
        userId: String,
        email: String? = nil,
        profileImageUrl: String? = nil,
        dateCreated: Date? = nil,
        age: Int? = nil,
        username: String? = nil,
        isJobber: Bool? = nil,
        preferences: [String]? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        profession: String? = nil
        

    ) {
        self.userId = userId
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.dateCreated = dateCreated
        self.age = age
        self.username = username
        self.isJobber = isJobber
        self.preferences = preferences
        self.firstName = firstName
        self.lastName = lastName
        self.profession = profession

    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case profileImageUrl = "profile_image_url"
        case dateCreated = "date_created"
        case age = "age"
        case username = "username"
        case isJobber = "is_jobber"
        case preferences = "preferences"
        case firstName = "first_name"
        case lastName = "last_name"
        case profession = "profession"

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.age = try container.decodeIfPresent(Int.self, forKey: .age)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.isJobber = try container.decodeIfPresent(Bool.self, forKey: .isJobber)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences )
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName )
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName )
        self.profession = try container.decodeIfPresent(String.self, forKey: .profession )

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.profileImageUrl, forKey: .profileImageUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.age, forKey: .age)
        try container.encodeIfPresent(self.username, forKey: .username)
        try container.encodeIfPresent(self.isJobber, forKey: .isJobber)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.profession, forKey: .profession)



    }
}

final class UserManager: ObservableObject {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    
    func createNewUser(user: DBUser) async throws {
        let data: [String: Any] = [
            "user_id": user.userId,
            "email": user.email ?? "not provided",
            "profile_image_url": user.profileImageUrl ?? "not provided",
            "date_created": user.dateCreated ?? Timestamp(),
            "age": user.age ?? 0,
            "username": user.username ?? "not provided",
            "is_jobber": user.isJobber ?? false
        ]
        
        try await userDocument(userId: user.userId).setData(data, merge: false)
    }
    
    
   /* func createNewUser(auth: AuthDataResultModel) async throws {
        
        var userData: [String:Any] = [
            "user_id" : auth.uid,
            "date_created" : Timestamp(),
            "email" : auth.email ?? "not provided",
            "photo_url" : auth.photoUrl ?? "not provided",
           /* "name": auth.name ?? "not provided",
            "username": auth.username ?? "not provided",
            "age": auth.age ?? "not provided",
            "is_jobber" : auth.isJobber ?? "not provided" */
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoUrl = auth.photoUrl {
            userData["photo_Url"] = photoUrl
        }
        
        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//      try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    */
    func getUser(userId: String) async throws -> DBUser {
        let documentSnapshot = try await userDocument(userId: userId).getDocument()
        
        guard let data = documentSnapshot.data() else {
            throw URLError(.badServerResponse)
        }
        
        guard let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let profileImageUrl = data["profile_image_url"] as? String
        let dateCreated = (data["date_created"] as? Timestamp)?.dateValue()
        let isJobber = data["is_jobber"] as? Bool
        let name = data["name"] as? String
        let username = data["username"] as? String
        let age = data["age"] as? Int
        
        return DBUser (
            userId: userId,
            email: email,
            profileImageUrl: profileImageUrl,
            dateCreated: dateCreated,
            age: age,
            username: username,
            isJobber: isJobber
        )
    }
    
    func updateUserInfo(userId: String, firstName: String, lastName: String, age: String, profession: String) async throws {
        let data: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "age": Int(age) ?? 0, // Convertir l'âge en entier
            "profession": profession
        ]

        do {
            // Utiliser `Task` pour exécuter la mise à jour de manière asynchrone
            try await Task {
                try await userDocument(userId: userId).setData(data, merge: true)
            }
        } catch {
            throw error
        }
    }
    
    func updateIsJobberStatus(isJobber: Bool, userId: String) async throws {
        
        let datas: [String:Any] = [
            DBUser.CodingKeys.isJobber.rawValue : isJobber
        ]
        try await userDocument(userId: userId).updateData(datas)
    }

    
/*    func getUser(userId: String) async throws -> DBUser {
        let snapshots = try await userDocument(userId: userId).getDocument()
//      let snapshots = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        
        guard let data = snapshots.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        let isJobber = data["is_jobber"] as? Bool
        let name = data["name"] as? String
        let username = data["username"] as? String
        let age = data["age"] as? Int

        return DBUser(userId: userId, email: email, photoUrl: photoUrl, dateCreated: dateCreated, age: age, username: username, isJobber: isJobber)
    }
 */
    
    func addUserPreference(userId : String, preference : String) async throws {
        let datas: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : [preference] //FieldValue.arrayUnion([preference])
        ]
        try await userDocument(userId: userId).updateData(datas)

    }
    
    func removeUserPreference(userId : String, preference: String) async throws {
        let datas: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        try await userDocument(userId: userId).updateData(datas)

    }
}
