//
//  ChatView 2.swift
//  MESS
//
//  Created by khush on 10/05/2026.
//


//
//  ContentView.swift
//  MESS
//
//  Created by khush on 27/04/2026.
//

import SwiftUI

struct BroadcastChatView: View {
    // @StateObject var socket = RawWebSocketManager()
    var username: String
    //    @StateObject var socket = WebSocketManager(socketUrl: "http://192.168.90.144:8080/")
    @StateObject var socket: BroadcastWebSocketManager
    
    @State private var messageInput = ""
    @State private var keyboardHeight: CGFloat = 0
    // @State public var isConnected: Bool = false
    @FocusState private var focus: Bool
    @State public var showingAlert = false
    @FocusState private var alertFocus: Bool
    @State public var SocketURL: String = "https://mess-backend-qseb.onrender.com"
//    var messageArray = ["Hi There !!", "How you're doin",  "Im glad, we could talk to you on a Private Server, where no one could read our conversations directly"]
//    struct MessageArray : Identifiable, Codable, Hashable {
//        var id: String
//        var message: String
//        var isSent: Bool
//    }
//    var messageArray: [MessageArray] = [["id": "2349987", "message": "Hello iOS", "IsSent": false], ["id": "2349987", "message": "Hello webclient", "IsSent": true]]
    
    init(username: String) {
        let url = "https://mess-backend-qseb.onrender.com"
        self.username = username
        _socket = StateObject(wrappedValue: BroadcastWebSocketManager(socketUrl: url, username: username))
        
    }
    
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView{
                ForEach(socket.broadcastMessageArray, id: \.self) { message in
                    BroadcastMessageBubble(message: Message(id: message.id ?? "1648255", message: message.message, isSent: message.isSent, timeStamp: Date()), displayName: message.displayName
                    )
                }
            }
            
            // .clipped()
            .safeAreaInset(edge: .top){
                //                MessageTitleRow(username: "Hideo Kojima", isConnected: socket.isConnected)
                //                    .padding(.horizontal)
                //                    .background(.ultraThinMaterial)
                //                    .navigationTitle("Hideo Kojima")
                Text("")
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    TextField("Message", text: $messageInput)
                        .focused($focus)
                        .padding() // between the text and inputbox
                        .background(Color("Foreground"))
                    // .background(.ultraThinMaterial)
                        .clipShape(.capsule)
                        .padding([.vertical, .leading], 10)
                        .focused($alertFocus)
                        .onSubmit {
                            // the same code from below (on button click)
                            socket.send(message: messageInput)
                            // manually rendering messages sent from device
                            socket.broadcastMessageArray.append(
                                MessageArray(
                                    id: "98741265",
                                    senderId: "",
                                    timeStamp: Date(),
                                    conversationId: "DEVBROADCAST", // always true, when sending
                                    message: messageInput,
                                    isSent: true,
                                    displayName: "iOS"
                                )
                            )
                            messageInput = ""
                        }
                    VStack {
                        HStack{
                            Button(action: {
                                if SocketURL == "http://" {
                                    showingAlert = true
                                    alertFocus = true
                                }
                                else {
                                    alertFocus = false
                                    showingAlert = false // fallback
                                    print("socket connection sent to:", SocketURL)
                                    socket.connect()
                                }
                            }){
                                Image(systemName: socket.isConnected ? "link.circle.fill" : "link")
                                    .padding()
                                    .background(Color("Foreground"))
                                    .clipShape(.capsule)
                                    .foregroundStyle(socket.isConnected ? .blue : .gray)
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.1).onEnded{ _ in
                                    showingAlert = true
                                    alertFocus = true
                                }
                            )
                            .sheet(isPresented: $showingAlert) {
                                connectionSheet
                                    .background(Color("Background"))
                            }
                            .alert("Error", isPresented: $socket.showAlert) {
                                Button("Cancel", role: .destructive) {}
                                Button("Reconnect", role: .cancel) {
                                    socket.connect()
                                }
                            } message: {
                                Text(socket.alertMessage)
                            }
                            Button(action: {
                                socket.send(message: messageInput)
                                // manually rendering messages sent from device
                                socket.broadcastMessageArray.append(
                                    MessageArray(
                                        id: "98741265",
                                        timeStamp: Date(),
                                        conversationId: "",
                                        message: messageInput,
                                        isSent: true, // always true, when sending
                                        displayName: ""
                                    )
                                )
                                messageInput = ""
                            }) {
                                Image(systemName: socket.isConnected ? "paperplane.fill" : "paperplane")
                                    .padding()
                                    .background(Color("Foreground"))
                                    .clipShape(.capsule)
                                    .foregroundStyle(socket.isConnected ? .blue : .gray)
                            }
                        }
                    }
                    // .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.vertical, .trailing], 10)
                }
                // .background(Color(.gray))
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
                .padding()
                .padding(.bottom, keyboardHeight)
                .animation(.easeOut(duration: 0.25), value: keyboardHeight)
            }
            .background(Color("Background"))
        }
        .onAppear {
            socket.connect()
//            KeyboardObserver()
        }
        .ignoresSafeArea(edges: .bottom) // for keeping the experience more better
        .background(Color("Background"))
    }
    
    func KeyboardObserver() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
                keyboardHeight = frame.height
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            keyboardHeight = 0
        }
    }
}

#Preview {
    BroadcastChatView(username: "Hideo Kojima")
}
