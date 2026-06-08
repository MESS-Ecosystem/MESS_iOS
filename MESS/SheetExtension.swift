//
//  SheetExtension.swift
//  MESS
//
//  Created by khush on 10/05/2026.
//

import SwiftUI

extension DMContentView {
    public var connectionSheet: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Enter Server URI")
                    .font(.title2)
                    .bold()
                Text("Please dont add '/' at the end of url")
                    .font(.caption)
                    .padding(.bottom)
                    .foregroundColor(.gray)
//                TextField(
//                    "Socket URI",
//                    text: $inputText
//                )
                
                .foregroundStyle(Color("ThemedText"))
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
                .padding(.horizontal)
                Button("Connect") {
//                    connectToServer()
                    showingAlert = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .foregroundColor(Color("ThemedText"))
                .clipShape(.capsule)
                .padding(.horizontal)
//                Spacer()
            }
            .padding()
            .navigationTitle("Connect")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(.ultraThinMaterial)
    }
}

extension BroadcastChatView {
    public var connectionSheet: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Enter Server URI")
                    .font(.title2)
                    .bold()
                Text("Please dont add '/' at the end of url")
                    .font(.caption)
                    .padding(.bottom)
                    .foregroundColor(.gray)
                TextField(
                    "Socket URI",
                    text: $SocketURL
                )
                
                .foregroundStyle(Color("ThemedText"))
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
                .padding(.horizontal)
                Button("Connect") {
                    DMWebSocketManager.shared.connect()
                    showingAlert = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .foregroundColor(Color("ThemedText"))
                .clipShape(.capsule)
                .padding(.horizontal)
//                Spacer()
            }
            .padding()
            .navigationTitle("Connect")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(.ultraThinMaterial)

    }
}
