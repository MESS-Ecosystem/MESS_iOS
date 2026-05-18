//
//  BroadcastContentView.swift
//  MESS
//
//  Created by khush on 10/05/2026.
//

import SwiftUI
import UIKit
struct BroadcastContentView: View {
    private var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    var body: some View {
        if !isIpad{
            NavigationView{
                BroadcastChatView(username: UIDevice.current.name)
                    .navigationTitle("Broadcast")
                //                .navigationBarTitleDisplayMode(.inline)
            }
        }
        else {
            BroadcastChatView(username: UIDevice.current.name)
            //                .navigationTitle("Broadcast")
            //                .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
}
#Preview {
    BroadcastContentView()
}
