//
//  SpineProjectApp.swift
//  SpineProject
//
//  Created by Ailidh Kinney on 08/08/2022.
//

import SwiftUI
import Firebase


@main
struct SpineProjectApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(ViewModel())
        }
    }
}
