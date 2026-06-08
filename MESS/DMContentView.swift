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
    @EnvironmentObject var chatListVM: ChatListViewModel
    // MARK: - Device Checks
    
    private var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    @State private var isNoURi: Bool = false
    private var shouldUseSidebar: Bool {
        isIpad && horizontalSizeClass == .regular
    }
    
    // MARK: - State
    @State public var showingAlert = false
//    @StateObject var PersistantController: PersistenceController = PersistenceController()
    
    
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
//            staticPreviewChat
            usersSection
        }
        .navigationTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                
                NavigationLink {
                    SearchView()
                        .navigationTitle("Search")
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
    
    private func deleteChatUser(at offsets: IndexSet) {
        offsets.forEach { index in
            let user = chatListVM.users[index]

            print("Deleting:", user.username)

            // CoreData delete code here
        }
    }
    
    var usersSection: some View {
        List {
            if chatListVM.users.isEmpty {
                Text("Search a user to chat with")
            } else {
                ForEach(chatListVM.users) { user in
                    NavigationLink {
                        ChatView(username: user.username)
                    } label: {
                        TitleRow(
                            username: user.username,
                            profile: user.profile,
                            isConnected: false,
                            unreadCount: user.unreadCount
                        )
                    }
                    //                    Text(user.username)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            print("Delete:", user.username)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .cancel) {
                            
                        } label: {
                            Label("Archive", systemImage: "archivebox")
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button() {
                            PersistantController.shared
                                .updateUnreadCount(username: user.username, unreadCount: 1)
                        } label: {
                            Label("Mark as Read", systemImage: "checkmark")
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button() {
                            
                        } label: {
                            Label("Mute", systemImage: "bell.slash")
                        }
                    }
//                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .background(Color("Background"))
                }
//                .onDelete(perform: deleteChatUser)
            }
        }
        .listStyle(.plain)
//        .scrollContentBackground(.hidden)
//        .background(Color.clear)
        .listRowInsets(.none)
        .listRowSeparator(.hidden)
        .frame(height: 500)
        .onAppear {
            chatListVM.getAllUsers()
            print(
                "USERS ON COREDATA:",
                chatListVM.users.count,
                chatListVM.users
            )
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
        .environmentObject(ChatListViewModel.shared)
}
