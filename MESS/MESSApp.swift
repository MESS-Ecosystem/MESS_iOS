//
//  MESSApp.swift
//  MESS
//
//  Created by khush on 27/04/2026.
//

import SwiftUI

@main
struct MESSApp: App {
    let persistence =
    PersistantController.shared
    
    var body: some Scene {
        WindowGroup {
            Landing()
                .environmentObject(
                    ChatListViewModel.shared
                )
                .environment(
                    \.managedObjectContext,
                     persistence.viewContext
                )
        }
    }
}
