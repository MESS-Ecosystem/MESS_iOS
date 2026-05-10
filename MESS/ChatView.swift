//
//  ContentView.swift
//  MESS
//
//  Created by khush on 27/04/2026.
//

import SwiftUI

struct ChatView: View {
    // @StateObject var socket = RawWebSocketManager()
    var socketURL: String
    var username: String
//    @StateObject var socket = WebSocketManager(socketUrl: "http://192.168.90.144:8080/")
    @StateObject var socket: BroadcastWebSocketManager
    
    @State private var messageInput = ""
    @State private var keyboardHeight: CGFloat = 0
    // @State public var isConnected: Bool = false
    @FocusState private var focus: Bool
    var messageArray = ["Hi There !!", "How you're doin",  "Im glad, we could talk to you on a Private Server, where no one could read our conversations directly"]
    
    init(socketURL: String, username: String) {
        self.socketURL = socketURL
        self.username = username
        
        _socket = StateObject(wrappedValue: BroadcastWebSocketManager(socketUrl: socketURL))
        
    }
    
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView{
                ForEach(messageArray, id: \.self) { text in
                    MessageBubble(message: Message(id: "12345", message: text, isSent: true, timeStamp: Date()))
                }
            }
            // .clipped()
            .safeAreaInset(edge: .top){
//                MessageTitleRow(username: "Hideo Kojima", isConnected: socket.isConnected)
//                    .padding(.horizontal)
//                    .background(.ultraThinMaterial)
//                    .navigationTitle("Hideo Kojima")
                Text("")
                    .navigationTitle(username)
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
                    VStack {
                        HStack{
                            Button(action: {
                                socket.connect()
                                print("socket connection sent")
                            }){
                                Image(systemName: socket.isConnected ? "link.circle.fill" : "link")
                                    .padding()
                                    .background(Color("Foreground"))
                                    .clipShape(.capsule)
                            }
                            Button(action: {
                                socket.send(message: messageInput)
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .padding()
                                    .background(Color("Foreground"))
                                    .clipShape(.capsule)
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
            KeyboardObserver()
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
    ChatView(socketURL: "http://localhost:8080",username: "Hideo Kojima")
}
