//
//  CompleteRegistrationView.swift
//  Jobb
//
//  Created by Léonard Dinichert on 23.11.2023.
//

import SwiftUI

struct CompleteRegistartionView: View {
        
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    @AppStorage("showSignInView") private var showSignInView: Bool = true

    @AppStorage("completeRegistrationViewIsShown") private var completeRegistrationViewIsShown: Bool = false

    var body: some View {
        VStack (spacing: 12) {
            
            Spacer()
            
            Text("Welcome to Jobb, \(RegistrationViewModel().username)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
                .multilineTextAlignment(.center)

            Button {
                Task { try await RegistrationViewModel().createUser()
                    showSignInView = false
}
            } label: {
                Text("Register")
            }
            .padding(.vertical)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture { completeRegistrationViewIsShown.toggle()
                }
            }
        }
    }
}

#Preview {
    CompleteRegistartionView()
}
