//
//  LoginPage.swift
//  Jobb
//
//  Created by Léonard Dinichert on 09.06.23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import FirebaseCore

/*struct EmailSignUpView: View {
 
 @StateObject private var viewModel = SignInEmailViewModel()
 
 var body: some View {
 
 VStack {
 
 Welcome()
 
 TextField("Adresse email", text: $viewModel.email)
 .padding()
 .background(.white)
 .cornerRadius(10)
 .shadow(radius: 3)
 .padding()
 
 SecureField("Mote de passe", text: $viewModel.password)
 .padding()
 .background(.white)
 .cornerRadius(10)
 .shadow(radius: 3)
 .padding()
 
 SecureField("Mote de passe", text: $viewModel.passwordVerification)
 .padding()
 .background(.white)
 .cornerRadius(10)
 .shadow(radius: 3)
 .padding()
 
 
 if viewModel.password == viewModel.passwordVerification || viewModel.passwordVerification == "" {
 HStack {
 Text("Les deux mots de passe correspondent")
 .foregroundColor(Color("Green"))
 
 Image(systemName: "checkmark.circle.fill")
 .foregroundColor(.green)
 .font(.title3)
 Spacer()
 }
 } else {
 HStack {
 Text("Les deux mots de passe ne correspondent pas")
 .foregroundColor(.red)
 
 Image(systemName: "multiply.circle.fill")
 .foregroundColor(.red)
 Spacer()
 }
 }
 
 
 Button  {
 
 Task {
 do {
 try await viewModel.signUp()
 AuthenticationViewModel().showSignInView = false
 } catch {
 print(error)
 }
 }
 
 } label: {
 ZStack {
 Rectangle()
 .frame(width: 150, height: 40)
 .cornerRadius(10)
 .foregroundColor(.white)
 .shadow(radius: 3)
 Text("Continuer")
 .foregroundColor(.black)
 .fontWeight(.medium)
 }
 .padding(.bottom, 30)
 }
 Text("Vous avez déjà un compte ?")
 
 NavigationLink {
 EmailSignInView()
 } label: {
 Text("Se connecter")
 .foregroundColor(Color("Green"))
 .fontWeight(.medium)
 }
 }
 }
 }
 
 
 
 struct ScreenLoginPageView_Previews: PreviewProvider {
 static var previews: some View {
 EmailSignUpView()
 }
 }
 
 struct Welcome: View {
 var body: some View {
 Text("Bienvenue !")
 .font(.largeTitle)
 .fontWeight(.bold)
 }
 }
 */


struct SignUpView: View {
    
    @AppStorage("showSignInView") private var showSignInView: Bool = true
    
    @StateObject private var vm = SignInWithGoogleModel()
    @StateObject private var viewModel = RegistrationViewModel()
    
    @AppStorage("completeRegistrationViewIsShown") private var completeRegistrationViewIsShown: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack {
                    Text("Welcome to Jobb !")
                    Text("Please first create an account to use Jobb")
                }
                .font(.title3)
                .fontWeight(.medium)
                
                VStack(spacing: 20) {
                    VStack {
                        
                        ZStack {
                            
                            Rectangle()
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .foregroundColor(.white)
                                .frame(height: 50)
                            
                            TextField("Enter your email", text: $viewModel.email)
                                .padding()
                            
                        }
                        ZStack {
                            
                            Rectangle()
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .foregroundColor(.white)
                                .frame(height: 50)
                            
                            SecureField("Enter your password", text: $viewModel.password)
                                .padding()

                        }
                        ZStack {
                            
                            Rectangle()
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .foregroundColor(.white)
                                .frame(height: 50)
                            
                            TextField("Enter your username",text: $viewModel.username)
                                .padding()

                        }
                        
                        Button {
                            completeRegistrationViewIsShown.toggle()
                            print($viewModel.username)
                            print($viewModel.password)
                            print($viewModel.email)
                            
                        } label: {
                            if viewModel.password.count < 6 {
                                Text("Sign Up")
                                    .disabled(viewModel.password.count > 6)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.gray)
                                    )
                                    .padding([.leading, .trailing])
                            } else {
                                Text("Sign Up")
                                    .disabled(viewModel.password.count < 6)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color("Green"))
                                    )
                                    .padding([.leading, .trailing])
                            }
                            
                        }
                        .navigationDestination(isPresented: $completeRegistrationViewIsShown) {
                            CompleteRegistartionView()
                                .navigationBarBackButtonHidden()
                        }
                    }
                    
                    Divider()
                        .frame(width: .infinity)
                    VStack {
                        Button {
                            vm.signInWithGoogle()
                        } label: {
                            HStack {
                                Image("google")
                                    .resizable()
                                    .frame(width: 36, height: 35)
                                
                                Text("Continue with Google")
                                    .padding(.horizontal, 60)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                            }
                            .padding(.horizontal, 17)
                            .padding(.vertical, 13)
                            .background {
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(Color(red: 248/255, green: 248/255, blue: 248/255))
                                    .strokeBorder(Color(red: 194/255, green: 194/255, blue: 194/255), lineWidth: 0.5)
                            }
                        }
                        
                        Button {
                            // se connecter avec apple
                        } label: {
                            HStack {
                                Image("appleDarkIcon")
                                    .resizable()
                                    .frame(width: 36, height: 35)
                                
                                Text("Continue with Apple")
                                    .padding(.horizontal, 60)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                            }
                            .padding(.horizontal, 17)
                            .padding(.vertical, 13)
                            .background {
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(Color(red: 248/255, green: 248/255, blue: 248/255))
                                    .strokeBorder(Color(red: 194/255, green: 194/255, blue: 194/255), lineWidth: 0.5)
                            }
                        }
                    }
                    
                    NavigationLink {
                        LogInView()
                            .environmentObject(LoginViewModel())
                            .environmentObject(vm)
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                            Text("Log In").bold()
                                .foregroundStyle(Color("Green"))
                        }
                        .foregroundStyle(.black)
                        
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    SignUpView()
}
