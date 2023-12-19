//
//  GoogleSignInViewModel.swift
//  Jobb
//
//  Created by Léonard Dinichert on 23.11.2023.
//

import SwiftUI
import Firebase
import GoogleSignIn

class SignInWithGoogleModel: ObservableObject {
    
    @AppStorage("showSignInView") private var showSignInView: Bool = false

    // Résoudre le problème d'affichage trop tôt du MainInterfaceView
    
    
    func signInWithGoogle() {
        // MARK: Get the AppClients ID
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // MARK: Create GoogleSignIn configuartion object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // MARK: SignIn method
        GIDSignIn.sharedInstance.signIn(withPresenting:  Application_utility.rootViewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                        
            Auth.auth().signIn(with: credential) { res, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = res?.user else { return }
                print(user)
                
            }
        }
        showSignInView = false
    }
}
