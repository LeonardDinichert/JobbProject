//
//  AuthenticationView.swift
//  TOD
//
//  Created by Léonard Dinichert on 08.07.23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth


/*@MainActor
 final class AuthenticationViewModelGoogle: ObservableObject {
 
 func signInGoogle() async throws {
 let helper = SignInGoogleHelper()
 let tokens = try await helper.signIn()
 let authDataResult = try await authenticationManager.shared.signInWithGoogle(tokens: tokens)
 let user = DBUser(from: authDataResult)
 try await UserManager.shared.createNewUser(user: user)
 //  AuthenticationViewModel.shared.showSignInView(true)
 }
 }
 
 */
struct AuthenticationView: View {
    
    @StateObject private var vm = SignInWithGoogleModel()
    
    var body: some View {
        
        ScrollView {
            NavigationStack {
                VStack (alignment: .leading) {
                    
                    Text("Créer toi un compte ou connecte toi !")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Green"))
                    
                    NavigationLink {
                        SignUpView()
                    } label: {
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .frame(width: .infinity, height: 50, alignment: .center)
                            
                            Text("Me créer un compte maintenant")
                                .foregroundColor(.primary)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    NavigationLink {
                        LogInView()
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .frame(width: .infinity, height: 50, alignment: .center)
                            Text("Me connecter à mon compte")
                                .foregroundColor(.primary)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    
                    NavigationLink {
                        
                        CollectInformationView()
                        
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .frame(width: .infinity, height: 50, alignment: .center)
                            Text("Continuer - collecte d'informations")
                                .foregroundColor(.primary)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .padding()
                    }
                    .navigationBarHidden(true) // Masque la barre de navigation
                    .navigationViewStyle(StackNavigationViewStyle()) // Désactive le geste de balayage pour revenir en arrière
                    
                    Text("Se connecter avec google")
                        .foregroundColor(.primary)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button {
                        vm.signInWithGoogle()
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .frame(width: .infinity, height: 50, alignment: .center)
                            Text("Me connecter avec google")
                                .foregroundColor(.primary)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .padding()
                }
                
                    Spacer()
                    
                }
                
                .padding()
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
