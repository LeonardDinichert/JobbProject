//
//  CreatingAccountView.swift
//  TOD
//
//  Created by Léonard Dinichert on 13.07.23.
//

import SwiftUI

struct CreatingAccountView: View {
    
@StateObject private var viewModel = CreateUserAccount()
@Binding var showSignInView: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CreatingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreatingAccountView(showSignInView: .constant(true))
    }
}
