//
//  ContentView.swift
//  MESS
//
//  Created by khush on 27/04/2026.
//

import SwiftUI

struct ChatView: View {
    @FetchRequest var messages: FetchedResults<ChatMessage>
    var username: String
    var userInfo: ChatUser?
    @State private var messageInput = ""
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var focus: Bool
    init(username: String) {
        self.username = username
        _messages = FetchRequest(
            sortDescriptors: [
                NSSortDescriptor(
                    key: "timeStamp",
                    ascending: true
                )
            ],
            predicate: NSPredicate(
                format: "conversationId == %@",
                username
            )
        )
        userInfo = PersistantController.shared.getUser(
            username: username
        )
    }
    
    
    func sendMessage () {
        if messageInput != "" {
            PersistantController.shared.saveMessage(
                conversationId: username,
                senderId: "me",
                message: messageInput,
                timeStamp: Date()
            )
            DMWebSocketManager.shared.send(message: messageInput)
            messageInput = ""
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(messages, id: \.objectID) { message in
                            MessageBubble(
                                message: Message(
                                    id: message.conversationId ?? "",
                                    message: message.message ?? "",
                                    isSent: message.senderId == "me",
                                    timeStamp: message.timeStamp ?? Date()
                                ),
                                profile: userInfo?.profile
                            )
                        }
                        MessageBubble(
                            message: Message(
                                id: "hq029837jeh",
                                message: "Hehe",
                                isSent: true,
                                timeStamp: Date()
                            ),
                            profile: nil
                        )
                    }
                    .onChange(of: messages.count) { newCount in
                        print("Messages count changed:", newCount)
                        guard let lastId = messages.last?.objectID else { return }
                        
                        DispatchQueue.main.async {
                            withAnimation (.easeInOut(duration: 1), {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            })
                        }
                    }
                }
                .onAppear {
                    //            KeyboardObserver()
                    //            socket.connect()
                    print("\n\n\n", messages, "\n\n\n")
                    DMWebSocketManager.shared.chat(with: username)
                }
                .onDisappear {
                    DMWebSocketManager.shared.closeChat(
                        with: username
                    )
                }
                .safeAreaInset(edge: .top){
                    Text("")
                        .navigationTitle(username)
                }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        TextField("Message", text: $messageInput)
                            .focused($focus)
                            .padding() // between the text and inputbox
                            .background(Color("Foreground"))
                            .clipShape(.capsule)
                            .padding([.vertical, .leading], 10)
                            .onSubmit {
                                sendMessage()
                            }
                        VStack {
                            HStack{
                                Button(action: {
                                    sendMessage()
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
                .ignoresSafeArea(edges: .bottom) // for keeping the experience more better
                .background(Color("Background"))
            }
//            .safeAreaInset(edge: .top, spacing: 0) {
//                Rectangle()
//                    .fill(.thinMaterial)
//                    .frame(height: 80)
//                BlurView(style: .systemUltraThinMaterial)
//                    .frame(height: 100)
//            }
        }
    }
    
//    struct BlurView: UIViewRepresentable {
//        let style: UIBlurEffect.Style
//        
//        func makeUIView(context: Context) -> UIVisualEffectView {
//            UIVisualEffectView(effect: UIBlurEffect(style: style))
//        }
//        
//        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
//    }
    
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
    ChatView(username: "Hideo Kojima")
}
