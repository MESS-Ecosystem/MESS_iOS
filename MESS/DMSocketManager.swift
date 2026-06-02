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
    
    @Published var isConnected: Bool = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    var manager: SocketManager!
    var socket: SocketIOClient!
    var socketUrl: String
    var username: String
    var displayName: String
    let token = KeychainManager.shared.getToken() ?? ""
    var authPayload: [String: Any] = ["token": ""]
    init(username: String, displayName: String? = "iOS") {
        self.socketUrl = "https://mess-backend-qseb.onrender.com/DM"
        self.username = username
        self.displayName = displayName ?? username
        self.authPayload = ["platformInfo": "\(UIDevice.current.name)", "username": username, "displayName": self.displayName,  "token": token]
        manager = SocketManager(
            socketURL: URL(string: socketUrl)!,
            config: [
                .log(true),
                .compress,
                .forceWebsockets(true)
            ]
        )
        socket = manager.defaultSocket

        setupListeners()
    }

    func connect() {
        socket.connect(withPayload: authPayload)
    }

    func disconnect() {
        socket.disconnect()
    }

    func send(message: String) {

        socket.emit("send-message", [
            "message": message
        ])
    }

    func setupListeners() {

        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("Connected to server")
            self?.isConnected = true
            
            DispatchQueue.main.async {
                self?.isConnected = true
            }
        }
        socket.on(clientEvent: .error) { [weak self] data, ack in
            print("error: ", data)
            if let errorData = data.first as? [String: Any],
               let message = errorData["message"] as? String {
                self?.alertMessage = message
                self?.showAlert = true
            } else {
                self?.alertMessage = "Unknown Auto Socket Error"
                self?.showAlert = true
            }
        }
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("Disconnected")
            self?.isConnected = false
            
            DispatchQueue.main.async {
                self?.isConnected = false
            }
        }

        socket.on("recieve-new-message") { data, ack in
            print("Message received:", data)
        }
    }
}
