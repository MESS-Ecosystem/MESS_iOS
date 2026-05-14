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
    @State private var users: [UserList] = []
    @State public var showingAlert = false
    @State public var inputText = "http://"
    
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
            connectionButton
            staticPreviewChat
            usersSection
        }
        .navigationTitle("Chats")
        .background(Color("Background"))
    }
}
// MARK: - Components
private extension DMContentView {
    var connectionButton: some View {
        HStack{
            if #available(iOS 26.0, *) {
                Button("Enter URi for Socket") {
                    showingAlert = true
                }
                .sheet(isPresented: $showingAlert) {
                    connectionSheet
                        .background(Color("Background"))
                }
                .padding()
                .background(.ultraThinMaterial)
                .foregroundStyle(
                    Color("ThemedText")
                )
                .clipShape(.capsule)
                .glassEffect(.regular.interactive(), in: .capsule)
            } else {
                Button("Enter URi for Socket") {
                    showingAlert = true
                }
                .sheet(isPresented: $showingAlert) {
                    connectionSheet
                        .background(Color("Background"))
                }
                .padding()
                .background(.ultraThinMaterial)
                .foregroundStyle(
                    Color("ThemedText")
                )
                .clipShape(.capsule)
            }
            if #available(iOS 26.0, *) {
                Button {
                    connectToServer()
                } label: {
                    Image(systemName: "link")
                }
                .alert("Important Message", isPresented: $isNoURi) {
                    Button("Enter URi", role: .cancel) { showingAlert = true; isNoURi = false }
                           Button("Cancel", role: .destructive) { isNoURi = false }
                       } message: {
                           Text("Please enter a URi to connect to server")
                       }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
                .glassEffect(.regular.interactive(), in: .capsule)
            } else {
                Button {
                    connectToServer()
                } label: {
                    Image(systemName: "link")
                }
                .alert("Important Message", isPresented: $isNoURi) {
                    Button("Enter URi", role: .cancel) { showingAlert = true; isNoURi = false }
                           Button("Cancel", role: .destructive) { isNoURi = false }
                       } message: {
                           Text("Please enter a URi to connect to server")
                       }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
            }
            
        }
    }
    
    var staticPreviewChat: some View {
        
        NavigationLink {
            ChatView(socketURL: inputText + "/DM", username: "Fragile")
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
private extension DMContentView {
    func userRow(_ user: UserList) -> some View {
        NavigationLink {
            ChatView(socketURL: inputText + "/DM",username: user.username)
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
extension DMContentView {
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
        
        if inputText == "" {
            isNoURi = true
        }
        let dmUserURL = inputText + "/dmusers"
        guard let url = URL(
            string: dmUserURL
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
                [UserList].self,
                from: data
            )
        print("recieved data: ", jsondata)
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
