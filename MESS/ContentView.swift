//
//  ContentView.swift
//  MESS
//
//  Created by khush on 07/05/2026.
//

import SwiftUI
struct ContentView: View {
    // MARK: - Environment
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    // MARK: - Device Checks

    private var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    private var shouldUseSidebar: Bool {
        isIpad && horizontalSizeClass == .regular
    }

    // MARK: - State
    @State private var users: [UserList] = []
    @State public var showingAlert = false
    @State public var inputText = ""

    // MARK: - Body

    var body: some View {
        Group {
            if #available(iOS 16, *) {
                modernNavigation
            } else {
                legacyNavigation
            }
        }
    }
}

// MARK: - Modern Navigation (iOS 16+)

@available(iOS 16.0, *)
private extension ContentView {
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
    }
}

// MARK: - Legacy Navigation (iOS 15)

private extension ContentView {
    var legacyNavigation: some View {
        NavigationView {
            chatList
                .navigationBarBackButtonHidden(isIpad)
        }
    }
}

// MARK: - Main Chat List UI
private extension ContentView {
    var chatList: some View {
        ScrollView {
            connectionButton
            staticPreviewChat
            usersSection
        }
        .navigationTitle("Chats")
    }
}
// MARK: - Components
private extension ContentView {
    var connectionButton: some View {
        Button("Enter URi for Socket") {
            showingAlert = true
        }
//        .alert(
//            "Enter URi",
//            isPresented: $showingAlert
//        ) {
//            TextField(
//                "Socket URi",
//                text: $inputText
//            )
//            Button("Connect") {
//                connectToServer()
//            }
//            Button(
//                "Cancel",
//                role: .cancel
//            ) {}
//
//        } message: {
//            Text(
//                "Please enter server's socket URi below."
//            )
//        }
        .sheet(isPresented: $showingAlert) {
            connectionSheet
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.capsule)
        .foregroundStyle(
            Color("ThemedText")
        )
    }

    var staticPreviewChat: some View {

        NavigationLink {
            ChatView(username: "Fragile")
        } label: {
            TitleRow(
                username: "Fragile",
                isConnected: true
            )
            .padding(.horizontal)
            .background(.ultraThinMaterial)
        }
    }
    var usersSection: some View {
        LazyVStack {
            ForEach(users) { user in
                userRow(user)
            }
        }
    }
}
// MARK: - User Row
private extension ContentView {
    func userRow(_ user: UserList) -> some View {
        NavigationLink {
            ChatView(
                username: user.username
            )
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
// MARK: - Networking
extension ContentView {
    public func connectToServer() {
        Task {
            do {
                users = try await fetchUsers()
            } catch {
                print(
                    "Failed fetching users:",
                    error
                )
            }
        }
    }
    func fetchUsers() async throws -> [UserList] {
        guard let url = URL(
            string: inputText
        ) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession
            .shared
            .data(from: url)
        return try JSONDecoder()
            .decode(
                [UserList].self,
                from: data
            )
    }
}
// MARK: - Models
struct UserList: Identifiable, Codable {
    let id: String
    let userId: String?
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
    ContentView()
}
