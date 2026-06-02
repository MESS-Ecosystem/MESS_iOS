//
//  ContentView.swift
//  MESS
//
//  Created by khush on 07/05/2026.
//

import SwiftUI
struct DMContentView: View {
    // MARK: - Environment
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    // MARK: - Device Checks
    
    private var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    @State private var isNoURi: Bool = false
    private var shouldUseSidebar: Bool {
        isIpad && horizontalSizeClass == .regular
    }
    
    // MARK: - State
    @State private var users: [UserList?] = []
    @State public var showingAlert = false
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Group {
                if #available(iOS 16, *) {
                    modernNavigation
                } else {
                    legacyNavigation
                }
            }
        }
    }
}

// MARK: - Modern Navigation (iOS 16+)

@available(iOS 16.0, *)
private extension DMContentView {
    var modernNavigation: some View {
        Group {
            if shouldUseSidebar {
                NavigationSplitView {
                    chatList
                        .navigationSplitViewColumnWidth(
                            min: 300,
                            ideal: 350
                        )
                } detail: {
                    EmptyChatView()
                }
            } else {
                NavigationStack {
                    chatList
                }
            }
        }
//        .background(Color("Background"))
    }
}

// MARK: - Legacy Navigation (iOS 15)

private extension DMContentView {
    var legacyNavigation: some View {
        NavigationView {
            chatList
//                .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(.columns)
    }
}

// MARK: - Main Chat List UI
private extension DMContentView {
    var chatList: some View {
        ScrollView {
//            connectionButton
            staticPreviewChat
            usersSection
        }
        .navigationTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                
                NavigationLink {
                    SearchView()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .background(Color("Background"))
    }
}
// MARK: - Components
private extension DMContentView {
    
    var staticPreviewChat: some View {
        NavigationLink {
            ChatView(username: "Raj Surani")
        } label: {
            TitleRow(
                username: "Raj Surani",
                isConnected: false
            )
            .padding(.horizontal)
            .background(.ultraThinMaterial)
        }
    }
    var usersSection: some View {
        LazyVStack {
            ForEach(users as! [UserList]) { user in
                userRow(user)
            }
        }
    }
}
// MARK: - User Row
private extension DMContentView {
    func userRow(_ user: UserList) -> some View {
        NavigationLink {
            ChatView(username: user.username)
        } label: {
            TitleRow(
                username: user.username,
                isConnected: true
            )
            .padding(.horizontal)
            .background(.ultraThinMaterial)
        }
    }
}
// MARK: - Models
struct UserList: Identifiable, Codable {
    let id: String
    let userId: UserDetails?
    let username: String
}
struct UserDetails: Codable {
    let platformInfo: String
    let username: String
}

// MARK: - Placeholder Detail View
struct EmptyChatView: View {
    var body: some View {
        VStack {
            Image(systemName: "message")
            Text("Select a chat")
        }
        .foregroundStyle(.secondary)
    }
}
// MARK: - Preview
#Preview {
    DMContentView()
}
