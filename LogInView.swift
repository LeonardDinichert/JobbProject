//
//  EmailSignInPageView.swift.swift
//  TOD
//
//  Created by Léonard Dinichert on 08.07.23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import FirebaseCore

struct LogInView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var vm: SignInWithGoogleModel
    @AppStorage("showSignInView") private var showSignInView: Bool = true

    
    var body: some View {
        VStack {
            
            Spacer()
            
            VStack {
                Text("Login to access your Jobb account")
            }
            .font(.title3)
            .fontWeight(.medium)
            
            Spacer()
            
            VStack(spacing: 20) {
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray, lineWidth: 1)
                        )
                        .padding([.leading, .trailing])
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray, lineWidth: 1)
                        )
                        .padding([.leading, .trailing])
                                        
                    Button {
                        Task { try await viewModel.signIn()
                                showSignInView = false
}
                    } label: {
                        Text("Log in with email")
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
                    
                    Divider()
                        .frame(width: 359)
                    
                    Button {
                        vm.signInWithGoogle()
                    } label: {
                        HStack {
                            Image("google")
                                .resizable()
                                .frame(width: 35, height: 35)
                            
                            Text("Continue with Google")
                                .padding(.horizontal, 60)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 13)
                        .background {
                            RoundedRectangle(cornerRadius: 13)
                                .fill(Color(red: 248/255, green: 248/255, blue: 248/255))
                                .strokeBorder(Color(red: 194/255, green: 194/255, blue: 194/255), lineWidth: 0.5)
                        }
                    }
                    
                    Button {
                        
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
                
                VStack {
                    HStack(spacing: 3) {
                        Text("No account?")
                            .foregroundStyle(.black)
                        Button {
                            dismiss()
                        } label: {
                            Text("Create one.").bold()
                                .foregroundStyle(Color("Green"))
                        }
                    }
                    NavigationLink {
                        ResetPasswordView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Forgot password?").bold().underline()
                            .foregroundStyle(Color("Green"))
                    }
                    .padding(.vertical, 12)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LogInView()
}
