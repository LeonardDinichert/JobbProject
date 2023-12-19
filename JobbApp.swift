//
//  TODApp.swift
//  TOD
//
//  Created by Léonard Dinichert on 27.05.23

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct JobbAppLogic: View {
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    @AppStorage("hasShownWelcome") private var hasShownWelcome: Bool = false

    var body: some View {
        
        if !hasShownWelcome {
            JobbIntroView()
        } else {
            MainInterfaceView()
        }
    }
}
    
    
struct MainInterfaceView: View {
    
    @StateObject var viewModel = AuthenticationViewModel()
    @AppStorage("showSignInView") private var showSignInView: Bool = true
    
    var body: some View {
        
        if showSignInView {
            SignUpView()
        } else {
            
            TabView {
                HomeView()
                    .tabItem {
                        Label("Jobbers", systemImage: "magnifyingglass")
                    }
                /*ScreenTwoMap()
                 .tabItem {
                 Label("Map", systemImage: "map.fill")
                 }
                 OfferPageView()
                 .tabItem {
                 Label("Offer", systemImage: "lane")
                 }*/
                ScreenThreeMessage()
                    .tabItem {
                        Label("Message", systemImage: "message")
                    }
                ScreenFourAccount()
                    .badge(1)
                    .tabItem {
                        Label("Acccount", systemImage: "person.fill")
                }
            }
        }
    }
}
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
            FirebaseApp.configure()
            
            return true
            
        }
    }
    
    
    @main
    struct JobbApp: App {
        
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
        var body: some Scene {
            
            WindowGroup {
                JobbAppLogic()
            }
        }
    }
    
    
    struct Separation: View {
        var body: some View {
            
            Rectangle()
                .frame(height: 1.2)
                .foregroundColor(Color("Light Green"))
                .opacity(0.5)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
        }
    }
