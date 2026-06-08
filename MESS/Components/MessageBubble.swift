//
//  MessageBubble.swift
//  MESS
//
//  Created by khush on 30/04/2026.
//

import SwiftUI
import Kingfisher

struct MessageBubble: View {
    var message: Message
    var profile: String?
    @State private var showTime = false
    @State private var didLoadImage = false

    var body: some View {
        VStack (alignment: message.isSent ? .trailing : .leading) {
            HStack(alignment: .bottom){
                if !message.isSent {
                    if profile != nil {
                        KFImage(URL(string: profile ?? "placeholderProfile"))
                            .placeholder {
                                ZStack {
                                    Image("placeholderProfile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .blur(radius: 20)
                                        .frame(maxWidth: 30, maxHeight: 30)
                                        .clipShape(.capsule)
                                    ProgressView()
                                        .tint(.white)
                                }
                            }
                            .onSuccess { _ in
                                withAnimation(
                                    .spring(
                                        response: 1,
                                        dampingFraction: 0.8,
                                        blendDuration: 1
                                    )
                                ) {
                                    didLoadImage = true
                                }
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: didLoadImage ? 0 : 20)
                            .scaleEffect(didLoadImage ? 1.0 : 1.15)
                            .frame(maxWidth: 30, maxHeight: 30)
                            .clipShape(.capsule)
                            .padding(.bottom, 5)
                    }
                    else {
                        Image("placeholderProfile")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.capsule)
                            .frame(maxWidth: 30, maxHeight: 30)
                    }
             }
                Text(message.message)
                    .padding()
                    .background(Color(message.isSent ? "Theme" : "ThemedGray"))
                    .cornerRadius(30)
                    .padding(message.isSent ? .leading : .trailing)
            }
            .frame(
                maxWidth: .infinity,
                alignment: message.isSent ? .trailing : .leading
            )
            .onTapGesture{
                withAnimation{
                    showTime.toggle()
                }
            }
            
            if showTime {
                Text("\(message.timeStamp.formatted(.dateTime.hour().minute()))")
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                    .font(.caption)
                    .transition(.opacity.combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isSent ? .trailing : .leading)
        .padding(message.isSent ? .trailing : .leading)
    }
}

#Preview {
    MessageBubble(message: Message(id: "12345", message: "This is a message block, that is being used just for the testing purposes only !!!", isSent: false, timeStamp: Date()))
    MessageBubble(message: Message(id: "12345", message: "Glad, I Didn't knew that !!!", isSent: true, timeStamp: Date()))
}
