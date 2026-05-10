//
//  Landing.swift
//  MESS
//
//  Created by khush on 09/05/2026.
//

import SwiftUI

struct Landing: View {
    var body: some View {
        TabView{
            ContentView()
                .padding(.bottom, 1)
                .background(Color("Background"))
                .tabItem {
                    Label {
                        Text("DM")
                    } icon: {
                        Image(systemName: "message")
                    }
                }
            
            ChatView(socketURL: "", username: "Broadcast")
                .padding(.bottom, 1)
                .background(Color("Background"))
                .tabItem{
                    Label {
                        Text("Broadcast")
                    } icon: {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                    }
                }
        }
        .padding(.top)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 20) // Effectively adds "padding" to the bottom safe area
        }
        
        
        //            VStack{
        //
        //                NavigationLink {
        //                    ContentView()
        //                } label: {
        //                    HStack{
        //                        Image(systemName: "person.line.dotted.person")
        //                        Text ("DM")
        //                    }
        //                    .foregroundStyle(Color("ThemedText"))
        //                    .padding()
        //                    .background(Color("Background"))
        //                    .clipShape(.capsule)
        //                }
        //
        //                NavigationLink {
        //                    ChatView(username: "Broadcast")
        //                } label: {
        //                    HStack{
        //                        Image(systemName: "antenna.radiowaves.left.and.right")
        //                        Text ("Broadcast")
        //                    }
        //                    .foregroundStyle(Color("ThemedText"))
        //                    .padding()
        //                    .background(Color("Background"))
        //                    .clipShape(.capsule)
        //
        //                }
        //            }
        
    }
}

#Preview {
    Landing()
}
