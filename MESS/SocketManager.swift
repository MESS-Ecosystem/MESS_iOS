//
//  SocketManager.swift
//  MESS
//
//  Created by khush on 06/05/2026.
//

import Foundation
import SocketIO

class WebSocketManager: ObservableObject {
    
    @Published var isConnected: Bool = false
    var manager: SocketManager!
    var socket: SocketIOClient!

    init(socketUrl: String) {
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
        socket.connect()
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
//            isConnected = true
            
            DispatchQueue.main.async {
                self?.isConnected = true
            }
        }

        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("Disconnected")
//            isConnected = false
            
            DispatchQueue.main.async {
                self?.isConnected = false
            }
        }

        socket.on("message") { data, ack in
            print("Message received:", data)
        }
    }
}
