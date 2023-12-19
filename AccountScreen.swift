//
//  ScreenFourAccount.swift
//  TOD
//
//  Created by Léonard Dinichert on 29.05.23.
//

import SwiftUI

struct ScreenFourAccount: View {
        
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Profil")
                        .foregroundColor(.primary)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    
                    NavigationLink {
                        
                        UserAccountDetail()
                        
                    } label: {
                        
                        HStack {
                            
                            Image("profileImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .cornerRadius(100)
                                .padding(.bottom)
                            
                            VStack {
                                Text("[Nom du compte]")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                
                                Text("Voir mon compte")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                            }
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                            
                        }
                    }
                    
                    Separation()
                    
                    NavigationLink {
                        UserWantsToBecomeJobberView()
                    } label: {
                        ZStack {
                            
                            Rectangle()
                                .cornerRadius(40)
                                .shadow(radius: 4)
                                .foregroundColor(.white)
                                .frame(height: 140)
                            
                            VStack (alignment: .leading) {
                                
                                Text("Devenir un Jobber")
                                    .fontWeight(.semibold)
                                    .font(.title3)
                                    .padding(.bottom, 10)
                                    .foregroundColor(.black)
                                
                                
                                Text("Inscrit toi en tant que jobber afin de pouvoir proposer tes services")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Text("Paramètres")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    
                }
                .padding()
                
                VStack {
                    
                    HStack {
                        logOutButton()
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 0))
                    
                    /*  HStack {
                     deleteAccountButton()
                     .foregroundColor(.red)
                     .font(.headline)
                     .fontWeight(.semibold)
                     Spacer()
                     }*/
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 0))
                    
                }
            }
        }
    }
}

struct ScreenFourAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenFourAccount()
    }
}

/*@MainActor
 final class SettingViewModel: ObservableObject {
 
 @Published var authProviders: [authProviderOption] = []
 @StateObject private var viewModelToogleShowSignInView = AuthenticationViewModel()
 
 
 func loadAuthProviders() {
 if let providers = try? authenticationManager.shared.getProviders() {
 authProviders = providers
 }
 }
 
 
 func logOut() throws {
 try authenticationManager.shared.signOut()
 }
 
 func deleteAccount() async throws {
 try await authenticationManager.shared.deleteAccount()
 AuthenticationViewModel().showSignInView = true
 
 }
 
 func resetPassword() async throws {
 let authUser = try authenticationManager.shared.getAuthenticatedUser()
 
 guard let email = authUser.email else {
 throw URLError(.fileDoesNotExist)
 }
 
 try await authenticationManager.shared.resetPassword(email: email)
 }
 
 func updateEmail() async throws {
 let email = "Hello123@gmail.com"
 try await authenticationManager.shared.updateEmail(email: email)
 }
 
 func updatePassword() async throws {
 let password = "helloworld"
 try await authenticationManager.shared.updatePassword(password: password)
 }
 
 }
 */

struct logOutButton: View {
    
    @State private var UserWantsToLogOut = false
    
    @AppStorage("showSignInView") private var showSignInView: Bool = true
    
    var body: some View {
        Button("Log out") {
            Task {
                do {
                    JobbAuthService.shared.signOut()
                    showSignInView = true
                    
                } catch {
                    print(error)
                }
            }
        }
        .alert("You have been logged out", isPresented: $UserWantsToLogOut) {
            Button("OK", role: .cancel) { }
        }
    }
}

/*struct deleteAccountButton: View {        // add delete account function
 
 @StateObject private var viewModel = AuthenticationViewModel()
 @State private var UserWantsToDeleteAccount = false
 
 
 var body: some View {
 
 Button("Delete account", role: .destructive) {
 UserWantsToDeleteAccount = true
 print("Ask for deleting password")
 }
 .alert("Etes vous sur de vouloir supprimer votre compte ? Cet action est irréversible", isPresented: $UserWantsToDeleteAccount) {
 Button("Oui", role: .destructive) {
 Task {
 do {
 print("Account deleted")
 SLAuthService.shared.signOut()
 
 } catch {
 print(error)
 }
 }
 }
 Button("Non", role: .cancel) { }
 }
 }
 }
 */


/*
 struct emailUpdateButton: View {        // add possibility to update email
 
 @StateObject private var viewModel = AuthenticationViewModel()
 
 var body: some View {
 Button("Update Email") {
 Task {
 do {
 try await viewModel.updateEmail()
 print("email updated  ")
 } catch {
 print(error)
 }
 }
 }
 }
 }
 */
