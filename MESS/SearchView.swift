//
//  SearchView.swift
//  MESS
//
//  Created by khush on 01/06/2026.
//

import SwiftUI

struct SearchView: View {
    struct userList: Decodable, Hashable {
        var username: String
        var displayName: String?
        var _id: String
        var email: String?
        var profile: String?
    }
    @State private var searchInput: String = ""
    @State private var searchedUser: [userList] = [userList(username: "userindb", _id: "6")]
    @State private var didLoadImage = false
    @State private var isSearching: Bool = false
    let imageTransaction: Transaction = {
        var t = Transaction()
        t.animation = .spring(
            response: 0.55,
            dampingFraction: 0.82,
            blendDuration: 0.2
        )
        return t
    }()
    var body: some View {
        VStack {
                HStack {
                    TextField("Search", text: $searchInput, prompt: Text("Search"))
                        .padding()
                        .background(.themedGray)
                        .clipShape(.capsule)
                    if isSearching {
                        ProgressView()
                            .padding(.leading, 5)
                    }
                }
                .padding()
                ScrollView {
                    ForEach(searchedUser, id: \.self) { user in
                        HStack {
                            if user.profile != nil {
                                AsyncImage(
                                    url: URL(string: user.profile ?? "placeholderProfile"),
                                    transaction: imageTransaction
                                ) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .blur(radius: didLoadImage ? 0 : 20)
                                            .scaleEffect(didLoadImage ? 1.0 : 1.15)
                                            .frame(maxWidth: 60, maxHeight: 60)
                                            .clipShape(.capsule)
                                            .onAppear {
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
                                        
                                    case .empty, .failure:
                                        ZStack {
                                            Image("placeholderProfile")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .blur(radius: 20)
                                                .frame(maxWidth: 60, maxHeight: 60)
                                                .clipShape(.capsule)
                                            ProgressView()
                                                .tint(.white)
                                        }
                                        
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(maxWidth: 60)
                                .clipShape(.capsule)
                            }
                            else {
                                Image("placeholderProfile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(.capsule)
                                    .frame(maxWidth: 60, maxHeight: 60)
                            }
                            Text(user.username)
                                .bold()
                                .font(.title2)
                                .padding()
                            Spacer()
                            Button(action: {
                                // add user to local chat list
                            }) {
                                Text("Chat")
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color("Background"))
            .onChange(of: searchInput) { newValue in
                Task {
                    do {
                        if newValue.count >= 3 {
                            withAnimation {
                                isSearching = true
                            }
                            //                            print("Searching:", newValue)
                            guard let encoded = newValue.addingPercentEncoding(
                                withAllowedCharacters: .urlQueryAllowed
                            ) else {
                                return
                            }
                            let users = try await API.get(
                                "https://mess-backend-qseb.onrender.com/account/search?username=\(encoded)",
                                type: [userList].self
                            )
                            //                            print("Response:", "\(String(describing: users))")
                            searchedUser = users
                            withAnimation {
                                isSearching = false
                            }
                        }
                    } catch {
                        print("ERROR:", error)
                    }
                }
            }
        .background(Color("Background"))
    }
}

#Preview {
    SearchView()
}
