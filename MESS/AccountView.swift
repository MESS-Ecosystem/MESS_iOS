//
//  AccountView.swift
//  MESS
//
//  Created by khush on 21/05/2026.
//

import SwiftUI
import Kingfisher

struct AccountView: View {
    @AppStorage("hasCompletedOnboarding") public var hasCompletedOnboarding: Bool = true
    var userData: KeychainManager.userPayload = KeychainManager.shared.getUserInfo() ?? KeychainManager.userPayload(username: "", email: "")
    init () {
        if userData.username == "" {
            withAnimation {
                hasCompletedOnboarding = false
            }
        }
    }
    @State private var didImageLoaded: Bool = false

    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    NavigationLink {
                        AccountEditView()
                            .navigationTitle("My Account")
                    } label: {
                        HStack {
                            if userData.profile != nil {
                                KFImage(URL(string: userData.profile ?? "placeholderProfile"))
                                    .placeholder {
                                        ZStack {
                                            Image("placeholderProfile")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 70)
                                                .blur(radius: 5)
                                                .clipShape(.capsule)
                                                .opacity(0.3)
                                            ProgressView()
                                                .tint(.white)
                                        }
                                    }
                                    .onSuccess { _ in
                                        withAnimation {
                                            didImageLoaded = true
                                        }
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .blur(radius: didImageLoaded ? 0 : 5)
                                    .scaleEffect(didImageLoaded ? 1 : 1.25)
                                    .frame(width: 100, height: 70)
                                    .clipShape(.capsule)
                            } else {
                                Image("placeholderProfile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 70)
                                    .clipShape(.capsule)
                            }
                            //                            .frame(width: 100, height: 70)
                            //                            .clipShape(.capsule)
                            Text(userData.username.capitalized)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color("ThemedText"))
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("ThemedGray"))
                        .clipShape(.capsule)
                        .padding()
                    }
                    // MARK: Group Container
                    ScrollView {
                        // MARK: Group 1
                        VStack(alignment: .leading, spacing: .zero) {
                            // MARK: Account
                            NavigationLink {
                                VStack {
                                    AccountEditView()
                                }
                                .navigationTitle("My Account")
                                .navigationBarTitleDisplayMode(.large)
                            } label: {
                                HStack {
                                    Image(systemName: "person.crop.circle")
                                    Text("Account")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial)
                                .font(.title3)
                                .foregroundStyle(Color("ThemedText"))
                            }
                            NavigationLink {
                                VStack {
                                    Text("Coming Soon!")
                                }
                                .navigationTitle("Privacy")
                                .navigationBarTitleDisplayMode(.large)
                            } label: {
                                HStack {
                                    Image(systemName: "key")
                                    Text("Privacy")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial)
                                .font(.title3)
                                .foregroundStyle(Color("ThemedText"))
                            }
                            NavigationLink {
                                VStack {
                                    Text("Coming Soon!")
                                }
                                .navigationTitle("Chats")
                                .navigationBarTitleDisplayMode(.large)
                            } label: {
                                HStack {
                                    Image(systemName: "message")
                                    Text("Chats")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial)
                                .font(.title3)
                                .foregroundStyle(Color("ThemedText"))
                            }
                            NavigationLink {
                                VStack {
                                    Text("Coming Soon!")
                                }
                                .navigationTitle("Notifications")
                                .navigationBarTitleDisplayMode(.large)
                            } label: {
                                HStack {
                                    Image(systemName: "bell.badge")
                                    Text("Notifications")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial)
                                .font(.title3)
                                .foregroundStyle(Color("ThemedText"))
                            }
                        }
                        
                        // MARK: Group 2
                        VStack {
                            NavigationLink {
                                VStack {
                                    Text("Coming Soon!")
                                }
                                .navigationTitle("Chat History")
                                .navigationBarTitleDisplayMode(.large)
                            } label: {
                                HStack {
                                    Image(
                                        systemName:
                                            "arrow.trianglehead.2.clockwise.rotate.90"
                                    )
                                    Text("Chat History")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial)
                                .font(.title3)
                                .foregroundStyle(Color("ThemedText"))
                            }
                        }
                        
                        // MARK: Group 3
                        VStack {
                            NavigationLink {
                                VStack {
                                    Text("Coming Soon!")
                                }
                                .navigationTitle("Help & feedback")
                                .navigationBarTitleDisplayMode(.large)
                            } label: {
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                    Text("Help & feedback")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial)
                                .font(.title3)
                                .foregroundStyle(Color("ThemedText"))
                            }
                        }
                    }
                    .background(Color("Background"))
                    .cornerRadius(24, corners: [.topLeft, .topRight])
                    .background(
                        LinearGradient(
                            colors: [.clear, Color("Background")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .navigationTitle("Account")
            }
            .navigationBarBackButtonHidden(true)
            
            //            VStack {
            //                Text("~ From MESS")
            //                    .font(.title3)
            //                    .bold()
            //                HStack {
            //                    Button("MESS for Android") {
            //
            //                    }
            //                    Button("MESS for Web") {
            //
            //                    }
            //                }
            //
            //            }
        }
        .background(Color("Background"))
    }
}

func convertImageToJPEG_Base64(image: UIImage, quality: CGFloat = 1.0) -> String? {
    // 1. Convert UIImage to JPEG Data
    guard let imageData = image.jpegData(compressionQuality: quality) else { return nil }
    
    // 2. Convert Data to Base64 String
    return imageData.base64EncodedString()
}

func uploadNewProfile(
    _ newImage: UIImage,
    isFresh: Bool
) async throws -> String {
    guard let token = KeychainManager.shared.getToken() else {
        throw URLError(.userAuthenticationRequired)
    }
    guard let url = URL(
        string: "https://mess-backend-qseb.onrender.com/account/profile"
    ) else {
        throw URLError(.badURL)
    }
    var request = URLRequest(url: url)
    request.httpMethod = isFresh ? "POST" : "PATCH"
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    request.setValue(
        "Bearer \(token)",
        forHTTPHeaderField: "Authorization"
    )
    // 24 hours
    request.timeoutInterval = 86400
    let base64String = convertImageToJPEG_Base64(
        image: newImage,
        quality: 0.5
    )
//    print(base64String?.prefix(100))
    let body = [
        "profile": base64String
    ]
    request.httpBody = try JSONSerialization.data(
        withJSONObject: body
    )
    let config = URLSessionConfiguration.default
    // 24 hours
    config.timeoutIntervalForRequest = 86400
    // 24 hours
    config.timeoutIntervalForResource = 86400
    let session = URLSession(
        configuration: config
    )
    do {
        let (data, response) = try await session.data(
            for: request
        )
        guard let httpResponse = response as? HTTPURLResponse else {
            return "Invalid Response"
        }
        let responseBody =
            String(data: data, encoding: .utf8) ?? "No body"
        print("STATUS:", httpResponse.statusCode)
        print("BODY:", responseBody)
        if (200...299).contains(httpResponse.statusCode) {
            return "Success"
        }
        return "Server Error (\(httpResponse.statusCode))"
    } catch {
        print("NETWORK ERROR:", error)
        return "Unexpected Network Error"
    }
}


struct AccountEditView: View {
    
    @State fileprivate var isLoggingOut: Bool = false
    @State private var inputImage: UIImage?
    @State private var showingImagePicker: Bool = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding:
    Bool = true
    
    var userData: KeychainManager.userPayload = KeychainManager.shared.getUserInfo() ?? KeychainManager.userPayload(username: "Anonymous", email: "")
    @State private var username: String = ""
    @State private var didLoadImage = false
    @State private var showImageCropper: Bool = false
    @State private var imageStatusAlert = false
    @State private var imageStatusResult: String = ""
    @State private var imageStatus: String = ""

    init () {
        print("inputImage", inputImage as Any)
        print("userImage", userData.profile as Any)
    }
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottom) {
                //                Image("userpreview")
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fill)
                //                    .frame(maxWidth: 400)
                //                    .clipShape(.capsule)
                //                    .padding()
                if inputImage != nil {
                    Image(uiImage: inputImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 400, maxHeight: 400)
                        .clipShape(.capsule)
                        .padding()
                } else {
                    if (userData.profile != nil) {
                        KFImage(URL(string: userData.profile ?? "placeholderProfile"))
                            .placeholder {
                                ZStack {
                                    Image("placeholderProfile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .blur(radius: 20)
                                        .frame(maxWidth: 400, maxHeight: 400)
                                        .clipShape(.capsule)
                                    //                                .opacity(0.3)
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
                            .frame(maxWidth: 400, maxHeight: 400)
                            .clipShape(.capsule)
                            .padding()
                    } else {
                        Image("placeholderProfile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 400)
                            .clipShape(.capsule)
                            .padding()
                    }
                }
                Menu {
                    Button("New Image", systemImage: "square.and.arrow.up") {
                        showingImagePicker = true
                    }
                    Button("Edit this Image", systemImage: "square.and.pencil") {
                        
                    }
                } label: {
                    HStack {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)
                            .tint(.themedText)
                        Text("Edit")
                            .foregroundStyle(Color("ThemedText"))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(.capsule)
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $inputImage)
                    }
                    
                }
                .padding()
                .offset(x: 100 ,y: 10)
                .onChange(of: inputImage) { _ in
                    guard let image = inputImage else { return }
                    Task {
                        do {
                            
                            let result = try await uploadNewProfile(
                                image,
                                isFresh: userData.profile == nil
                            )
                            print("RESULT:", result)
                            try await KeychainManager.shared.refreshToken()
                            imageStatusResult = "\(String(result))"
                            imageStatus = "Success"
                            imageStatusAlert = true
                        } catch {
                            print("ERROR:", error)
                            imageStatusResult = "\(error)"
                            imageStatus = "Error"
                            imageStatusAlert = true
                        }
                    }
                }
                .alert("Image Upload Status", isPresented: $imageStatusAlert) {
                            Button("OK") { }
                    if imageStatus == "Error" {
                        Button("Retry", role: .destructive) {}
                    }
                       } message: {
                           VStack {
//                               Text("This is the detailed description of the alert.")
//                                   .font(.title3)
                               Text("status: \(imageStatus) \(imageStatusResult)")
                           }
                       }
            }
            //            .padding()
            TextField("username", text: $username)
                .padding()
                .background(Color("ThemedGray"))
                .clipShape(.capsule)
                .padding()
                .onAppear {
                    username = userData.username
                }
            
            Button(action: {}) {
                Text("Forgot Password?")
            }
            
            HStack {
                Button(action: {
                    Task {
                        try await KeychainManager.shared.refreshToken()
                    }
                }) {
                    Text("Refresh Token")
                        .foregroundStyle(.green)
                        .padding()
                        .padding(.horizontal)
                        .background(.ultraThinMaterial)
                        .clipShape(.capsule)
                }
                
                Button(action: { isLoggingOut = true }) {
                    Text("Log Out")
                        .foregroundStyle(.red)
                        .padding()
                        .padding(.horizontal)
                        .background(.ultraThinMaterial)
                        .clipShape(.capsule)
                }.alert("Log Out", isPresented: $isLoggingOut) {
                    Button("Confirm", role: .destructive) {
                        withAnimation {
                            KeychainManager.shared.deleteToken()
                            hasCompletedOnboarding = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AccountView()
        .onAppear {
            KeychainManager.shared.saveToken(
                token:
                    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InJhanN1cmFuaSIsImVtYWlsIjoicmFqc3VyYW5pMDM5QGdtYWlsLmNvbSIsInByb2ZpbGUiOiJodHRwczovL2VuY3J5cHRlZC10Ym4wLmdzdGF0aWMuY29tL2ltYWdlcz9xPXRibjpBTmQ5R2NUbW40cFdyREUxZjA3TmlPXy1BTEFQVzE4bVVjaGY2dmo5b0EmcyIsIl9pZCI6InJhbmRvbU9uamVjdElEIiwiaWF0IjoxNTE2MjM5MDIyfQ.MoPWPse_nFxxE3rm7WHKsPRUzy5dWVlloQZZZQ35mms"
            )
        }
}
