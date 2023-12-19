//
//  Application_Utility.swift
//  Jobb
//
//  Created by Léonard Dinichert on 23.11.2023.
//

import SwiftUI
import UIKit

final class Application_utility: UIViewController {
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
