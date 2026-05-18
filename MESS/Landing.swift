//
//  Landing.swift
//  MESS
//
//  Created by khush on 09/05/2026.
//

import SwiftUI
import Foundation
struct Landing: View {
    @AppStorage("hasCompletedOnboarding") public var hasCompletedOnboarding: Bool = false
    @State public var status: StatusPing = StatusPing(
        status: "0", databaseState: "disconnected"
    )
    private var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    var body: some View {
        if hasCompletedOnboarding {
            TabView{
                DMContentView()
                    .padding(.bottom, 1)
                    .background(isIpad ? Color.clear : Color("Background"))
                    .tabItem {
                        Label {
                            Text("DM")
                        } icon: {
                            Image(systemName: "message")
                        }
                    }
                
                //            BroadcastChatView(socketURL: "http://", username: "Broadcast")
                BroadcastContentView()
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
            //        .padding(.top)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 20) // Effectively adds "padding" to the bottom safe area
            }
            .ignoresSafeArea(edges: .top)
            .task {
                do {
                    status = try await pingServer()
                } catch {
                    print(error)
                }
            }
        }
        else {
            OnboardingView()
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
    struct StatusPing: Codable {
        var status: String
        var databaseState: String
    }
    func pingServer() async throws -> StatusPing {
        print("confirming server status !")
        let serverURL = "https://mess-backend-qseb.onrender.com/"
        guard let url = URL(
            string: serverURL
        ) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession
            .shared
            .data(from: url)
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON String: \(jsonString)")
        }
        let jsondata = try JSONDecoder()
            .decode(
                StatusPing.self,
                from: data
            )
        print("Status: ", jsondata)
        return try JSONDecoder()
            .decode(
                StatusPing.self,
                from: data
            )
    }
}

#Preview {
    Landing()
        .onAppear {
            // Wipes the setting ONLY inside the preview environment canvas
            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        }
}
