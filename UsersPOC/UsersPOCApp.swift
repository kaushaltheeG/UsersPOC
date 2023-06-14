//
//  UsersPOCApp.swift
//  UsersPOC
//
//  Created by Kaushal Kumbagowdana on 6/13/23.
//

import SwiftUI

@main
struct UsersPOCApp: App {
    let isProduction: AppState
    init() {
        // path to set variable or env: Product -> Scheme -> Edit Scheme -> Run -> Toggle to Variable
        // Can be accessed like
         // 1
//            let userIsSignIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false;
         // 2
        let checkingState: Bool = ProcessInfo.processInfo.arguments.contains("ProductionState") ? true : false
        self.isProduction = checkingState ? AppState.production : AppState.testing
    }
    var body: some Scene {
        
        WindowGroup {
            ContentView(appState: isProduction)
        }
    }
}
