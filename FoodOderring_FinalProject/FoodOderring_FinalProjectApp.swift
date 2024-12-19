//
//  FoodOderring_FinalProjectApp.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 30/9/24.
//

import SwiftUI
import FirebaseCore

@main
struct FoodOderring_FinalProjectApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
                //WelcomeView()
            ContentView()
        }
    }
}

//class AppDelegate : NSObject, UIApplicationDelegate{
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
