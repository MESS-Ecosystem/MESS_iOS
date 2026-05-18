//
//  SocketManager.swift
//  MESS
//
//  Created by khush on 06/05/2026.
//

import Foundation
import SocketIO
import UIKit
import SwiftUI

class BroadcastWebSocketManager: ObservableObject {

    @Published var isConnected: Bool = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    var manager: SocketManager!
    var socket: SocketIOClient!
    var socketUrl: String
    var username: String
    var displayName: String
//    public struct MessageArray : Identifiable, Codable, Hashable {
//        var id: String
//        var message: String
//        var isSent: Bool
//    }
    @Published var broadcastMessageArray: [MessageArray] = [
        MessageArray(
            id: "65487213",
            message: "Hello iOS!!",
            isSent: false,
            displayName: "Sam"
        ),
        MessageArray(
            id: "98741265",
            message: "Hello webclient!!",
            isSent: true,
            displayName: ""
        )
    ]
    init(socketUrl: String, username: String, displayName: String? = "iOS") {
        self.socketUrl = socketUrl
        self.username = username
        self.displayName = displayName ?? username
        manager = SocketManager(
            socketURL: URL(string: socketUrl)!,
            config: [
                .log(true),
                .compress,
                .forceWebsockets(true),
                .connectParams(["platformInfo": UIDevice.current.name])
            ]
        )

        socket = manager.defaultSocket

        setupListeners()
    }

    func connect(to incomingSocketUrl: String) {
        self.socketUrl = incomingSocketUrl
        print("on socket, connecting to:", self.socketUrl)
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func send(message: String) {
        let devinfo = UIDevice.current.name
        socket.emit( "send-message", ["message": message, "displayName": self.displayName, "IsSent": false, "uid": devinfo ] )
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
//            messageArray.append(data)
            guard let raw = data.first else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: raw)
                
                let decoded = try JSONDecoder().decode(
                    MessageArray.self,
                    from: jsonData
                )
                DispatchQueue.main.async {
                    self.broadcastMessageArray.append(decoded)
                }
            } catch {
                print(error)
            }
        }
    }
}
