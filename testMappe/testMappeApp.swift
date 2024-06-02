//
//  testMappeApp.swift
//  testMappe
//
//  Created by Christian Catenacci on 05/04/24.
//

import SwiftUI
import SDWebImageSVGCoder
import FirebaseCore
import SDWebImageSVGCoder


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}



@main
struct TooPoopToGo: App {
    init() {
        setUpDependencies() 
    }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private extension TooPoopToGo {
    
    func setUpDependencies() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}


