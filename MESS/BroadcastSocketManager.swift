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
import CoreData


class RecievePersistenceController {
    static let shared = RecievePersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Auth") // Use your .xcdatamodeld filename
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}


class BroadcastWebSocketManager: ObservableObject {

    @Published var isConnected: Bool = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true)],
//        animation: .default)
//    private var token: FetchedResults<Auth>
    var manager: SocketManager!
    var socket: SocketIOClient!
    var socketUrl: String = "https://mess-backend-qseb.onrender.com/"
    var username: String
    var displayName: String
    let token = KeychainManager.shared.getToken() ?? ""
    var authPayload: [String: Any] = ["token": ""]
//    public struct MessageArray : Identifiable, Codable, Hashable {
//        var id: String
//        var message: String
//        var isSent: Bool
//    }
    @Published var broadcastMessageArray: [MessageArray] = [
//        MessageArray(
//            id: "65487213",
//            message: "Hello iOS!!",
//            isSent: false,
//            displayName: "Sam"
//        ),
//        MessageArray(
//            id: "98741265",
//            message: "Hello webclient!!",
//            isSent: true,
//            displayName: ""
//        )
    ]
    init(socketUrl: String?, username: String, displayName: String? = "iOS") {
        if socketUrl != nil {
            self.socketUrl = socketUrl ?? "https://mess-backend-qseb.onrender.com/"
        }
        self.username = username
        self.displayName = displayName ?? username
        self.authPayload = ["platformInfo": "\(UIDevice.current.name)", "username": username, "displayName": self.displayName,  "token": token]
        print("token at init: ", token)
        
        manager = SocketManager(
            socketURL: URL(string: socketUrl!)!,
            config: [
                .log(true),
                .compress,
                .forceWebsockets(true),
//                .connectParams(["platformInfo": "\(UIDevice.current.name)", "username": username, "displayName": self.displayName,  "token": token])
            ]
        )

        socket = manager.defaultSocket

        setupListeners()
    }

    func connect() {
        print("on socket, connecting to:", self.socketUrl)
        socket.connect(withPayload: authPayload)
    }

    func disconnect() {
        socket.disconnect()
    }

    func send(message: String) {
        if message != "" {
            let devinfo = UIDevice.current.name
            socket.emit( "send-message", ["message": message, "displayName": self.displayName, "IsSent": false, "uid": devinfo ] )
        }
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
