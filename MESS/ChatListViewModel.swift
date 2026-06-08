//
//  ChatListViewModel.swift
//  MESS
//
//  Created by khush on 03/06/2026.
//

import Foundation

@MainActor
final class ChatListViewModel: ObservableObject {

    static let shared = ChatListViewModel()

    @Published var users: [ChatViewModel] = []

    func getAllUsers() {

        users = PersistantController.shared
            .getAllChatUsers()
            .map {
                ChatViewModel(
                    id: $0.objectId ?? "",
                    username: $0.username ?? "",
                    displayName: $0.displayName,
                    email: $0.email,
                    profile: $0.profile,
                    unreadCount: $0.unreadCount
                )
            }
    }

    func getUser(_ username: String) -> ChatViewModel? {

        guard let user = PersistantController.shared
            .getUser(username: username)
        else {
            return nil
        }

        return ChatViewModel(
            id: user.objectId ?? "",
            username: user.username ?? "",
            displayName: user.displayName,
            email: user.email,
            profile: user.profile,
            unreadCount: user.unreadCount
        )
    }

    func deleteUser(_ username: String) {
        PersistantController.shared.deleteUser(username: username)
        getAllUsers()
    }

    func saveUser(_ user: ChatViewModel) {

        PersistantController.shared.saveUser(
            username: user.username,
            displayName: user.displayName,
            email: user.email,
            profile: user.profile,
            objectId: user.id,
            unreadCount: nil
        )

        getAllUsers()
    }
}

struct ChatViewModel: Identifiable {
    let id: String
    let username: String
    let displayName: String?
    let email: String?
    let profile: String?
    let unreadCount: Int32
}
