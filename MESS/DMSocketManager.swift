//
//  DMSocketManager.swift
//  MESS
//
//  Created by khush on 10/05/2026.
//

import Foundation
import SocketIO
import UIKit

class DMWebSocketManager: ObservableObject {
    
    static let shared = DMWebSocketManager()

        @Published var isConnected = false

        var manager: SocketManager!
        var socket: SocketIOClient!
        var chattingWith: String?
        var authPayload: [String: Any]
        private let token =
            KeychainManager.shared.getToken() ?? ""

        private let username =
            KeychainManager.shared
                .getUserInfo()?
                .username ?? "Anonymous"
        private init() {
            self.authPayload = [
                "platformInfo": UIDevice.current.name,
                "username": username,
                "token": token
            ]
            manager = SocketManager(
                socketURL: URL(
                    string: "https://mess-backend-qseb.onrender.com/DM"
                )!,
                config: [
                    .log(true),
                    .compress,
                    .forceWebsockets(true)
                ]
            )
            socket = manager.defaultSocket
            setupListeners()
            socket.connect(
                withPayload: self.authPayload
            )
        }

    func connect() {
        socket.connect(withPayload: authPayload)
    }

    func disconnect() {
        socket.disconnect()
    }

    func send(message: String) {
        guard socket.status == .connected else {
                print("Socket not connected")
                return
            }
        socket.emit("send-message", [
            "message": message
        ])
    }
    
    func chat(with: String) {
        socket.emit("chatwith", [
            "username": with
        ])
        chattingWith = with
    }
    
    func closeChat(with: String) {
        socket.emit("closedChat", [
            "username": with
        ])
        chattingWith = nil
    }
    
    func typing() {
        socket.emit("am-typing")
    }

    func setupListeners() {

        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("\n\n\nConnected to server\n\n\n")
            self?.isConnected = true
            
            DispatchQueue.main.async {
                self?.isConnected = true
            }
        }
        socket.on(clientEvent: .error) { data, ack in
            print("\n \n \n error: ", data, "\n\n\n")
            if let errorData = data.first as? [String: Any],
               let _ = errorData["message"] as? String {
            }
        }
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("\n\n\nDisconnected\n\n\n")
            self?.isConnected = false
            
            DispatchQueue.main.async {
                self?.isConnected = false
            }
        }

        struct LiveNotification: Codable {
            let username: String?
            let message: String
            let timeStamp: Date?
            let isSent: Bool?
        }
        socket.on("recieve-new-message") { data, ack in
            print("\n\n\n\n\nMessage received:", data)
            guard
                let dict = data.first as? [String: Any],
                let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                let notification = try? JSONDecoder().decode(LiveNotification.self, from: jsonData)
            else {
                return
            }
            if self.chattingWith != nil {
                PersistantController.shared.saveMessage(
                    conversationId: self.chattingWith!,
                    senderId: self.chattingWith!,
                    message: notification.message,
                    timeStamp: notification.timeStamp ?? Date()
                )
            }
        }
        struct DMNotification: Codable {
            let username: String
            let timeStamp: Date
            let roomId: String
            let message: String?
            let content: String?
        }
        socket.on("dm-notification") { data, ack in
            print("\n\nDM: ", data, "\n\n")
            guard
                let dict = data.first as? [String: Any],
                let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                let notification = try? JSONDecoder().decode(DMNotification.self, from: jsonData)
            else {
                return
            }
            PersistantController.shared.saveMessage(
                conversationId: notification.username,
                senderId: notification.username,
                message: notification.message ?? notification.content ?? "",
                timeStamp: notification.timeStamp
            )
        }
        socket.on("is-typing") { data, ack in
            
        }
    }
}
