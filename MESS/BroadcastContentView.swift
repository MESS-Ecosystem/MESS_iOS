//
//  BroadcastContentView.swift
//  MESS
//
//  Created by khush on 10/05/2026.
//

import SwiftUI
import UIKit
struct BroadcastContentView: View {
    var body: some View {
        NavigationView{
            BroadcastChatView(socketURL: "http://", username: UIDevice.current.name)
                .navigationTitle("Broadcast")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BroadcastContentView()
}
