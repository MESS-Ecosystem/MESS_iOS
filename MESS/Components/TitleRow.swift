//
//  TitleRow.swift
//  MESS
//
//  Created by khush on 28/04/2026.
//

import SwiftUI
import Kingfisher

struct TitleRow: View {

    var username: String
    @State var isConnected: Bool
    var profile: String?
    @State private var didLoadImage = false
    @State private var unreadCount: Int32

    init(username: String = "samporterbridges", profile: String? = nil, isConnected: Bool, unreadCount: Int32){
        self.username = username
        self.isConnected = isConnected
        self.profile = profile
        self.unreadCount = unreadCount
    }
    
    var body: some View {
        HStack(spacing: 15){
//            Image(profile)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 50, height: 50)
//                .clipShape(.circle)
            
            if profile != nil {
                KFImage(URL(string: profile ?? "placeholderProfile"))
                    .placeholder {
                        ZStack {
                            Image("placeholderProfile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .blur(radius: 20)
                                .frame(width: 60, height: 60)
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
                    .frame(width: 60, height: 60)
                    .clipShape(.capsule)
            }
            else {
                Image("placeholderProfile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.capsule)
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading){
                Text(username)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.title2)
                    .foregroundStyle(Color("ThemedText"))
                if isConnected {
                    Text("Online")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .transition(.opacity)
                }
            }
            
            Spacer()
            HStack (alignment: .center){
                if unreadCount != 0 {
                    Text("\(String(describing: unreadCount))")
                        .font(.callout.bold())
                        .padding()
                        .background(.themedGray)
                        .clipShape(.circle)
                }
                Image(systemName: "phone.fill")
                    .foregroundStyle(.gray)
                    .clipShape(.circle)
                    .padding(10)
                    .background(.white)
                    .clipShape(.circle)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing)
        .onAppear() {
            print(String(describing: unreadCount))
        }
    }
}

#Preview {
    TitleRow(isConnected: false, unreadCount: 2)
        .background(Color("Background"))
        .clipShape(.capsule)
        .padding()
}
