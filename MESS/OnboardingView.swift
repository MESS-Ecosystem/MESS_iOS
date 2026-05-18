//
//  OnBoardingView.swift
//  MESS
//
//  Created by khush on 17/05/2026.
//

import SwiftUI
import CoreData
// 1. Define your onboarding data model
struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

enum authType {
    case login
    case register
}

struct OnboardingPageView: View {
    var item: Int
    @State private var loginUsernameInput: String = ""
    @State private var loginPasswordInput: String = ""
    @State private var registerUsernameInput: String = ""
    @State private var registerEmailInput: String = ""
    @State private var registerPasswordInput: String = ""
    @State private var registerConfirmPasswordInput: String = ""
    
    @State private var isSecured: Bool = true
    @State private var isEmptyAccount: Bool = false
    @State public var loginState: Int = 1
    @State public var authType: authType = .login
    @Binding var switchBinding: Int
    @State public var errorMessage: String = ""
    @State public var isLoading: Bool = false
    init (item: Int, switchBinding: Binding<Int>) {
        self.item = item
        self._switchBinding = switchBinding
    }
    
    var body: some View {
        HStack{
            if switchBinding==0 {
                Text("Welcome to")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("MESS")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            } else if switchBinding==1{
                
                VStack{
                    Text("Everyone Loves their own Identity")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                    if authType == .login {
                        
                        VStack{
                            HStack{
                                Button (action: { isEmptyAccount = true }) {
                                    Image(systemName: "person.fill")
                                        .accentColor(.gray)
                                }
                                .alert("Account Manager", isPresented: $isEmptyAccount) {
                                    
                                    Button(action: { isEmptyAccount = false }) {
                                        Text("Ok")
                                    }
                                } message: {
                                    Text("No previous Account found")
                                }
                                TextField(text: $loginUsernameInput) {
                                    Text("username")
                                        .foregroundStyle(Color("ThemedText").opacity(0.25))
                                }
                                .padding() // between text and border, inner spacing
                                .background(Color("Background"))
                                .clipShape(.capsule)
                                .foregroundStyle(Color("ThemedText"))
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                            }
                            .padding(.horizontal) // outer spacing
                            
                            
                            //                        SecureField(text: $passwordInput) {
                            //                            Text("password")
                            //                                .foregroundStyle(Color("ThemedText").opacity(0.25))
                            //                        }
                            HStack{
                                if isSecured {
                                    SecureField("Password", text: $loginPasswordInput)
                                    //                                  .textFieldStyle(.roundedBorder)
                                        .textContentType(.password)
                                    //                                  .disableAutocorrection(true)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .padding() // between text and border, inner spacing
                                        .background(Color("Background"))
                                        .clipShape(.capsule)
                                        .foregroundStyle(Color("ThemedText"))
                                } else {
                                    TextField("Password", text: $loginPasswordInput)
                                        .textContentType(.password)
                                    //                                  .disableAutocorrection(true)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .padding() // between text and border, inner spacing
                                        .background(Color("Background"))
                                        .clipShape(.capsule)
                                        .foregroundStyle(Color("ThemedText"))
                                        .onSubmit {
                                            isLoading = true
                                            withAnimation {
                                                errorMessage = ""
                                            }
                                            login(username: loginUsernameInput, password: loginPasswordInput, errorMessage: $errorMessage, loadingController: $isLoading, loginState: $loginState)
                                        }
                                    
                                }
                                Button(action: { withAnimation { isSecured.toggle() } }) {
                                    Image(systemName: isSecured ? "eye.slash" : "eye")
                                        .accentColor(.gray)
                                }
                            }
                            .padding(.horizontal) // outer spacing
                            .padding(.vertical, 10)
                            if errorMessage != "" {
                                Text(errorMessage)
                                    .foregroundStyle(.red)
                                    .transition(.opacity)
                            }
                            //                        Button("Login", systemImage: "lock", role: .none) {
                            //                            ProgressView {
                            //                                Text("Login")
                            //                            }
                            //                            withAnimation {
                            //                                errorMessage = ""
                            //                            }
                            //                            login(username: usernameInput, password: passwordInput, errorMessage: $errorMessage)
                            //                        }
                            Button(action: {
                                isLoading = true
                                withAnimation {
                                    errorMessage = ""
                                }
                                login(username: loginUsernameInput, password: loginPasswordInput, errorMessage: $errorMessage, loadingController: $isLoading, loginState: $loginState)
                            }){
                                HStack{
                                    ZStack {
                                        if isLoading {
                                            ProgressView()
                                                .tint(.blue) // Matches label color
                                        } else {
                                            if loginState==0 {
                                                Image(systemName: "checkmark.seal.fill")
//                                                    .foregroundStyle(.green)
                                            }
                                            else if loginState == 1 {
                                                Image(systemName: "lock")
                                            } else {
                                                Image(systemName: "personalhotspot.slash")
                                                    .foregroundStyle(.red)
                                            }
                                        }
                                    }
                                    Text("Login")
                                }
                            }
                            //                      .frame(maxWidth: .infinity)
                            .padding() // inner
                            .padding(.horizontal) // for a proper ratio among vertical and horizontal spacing
                            .background(.ultraThinMaterial)
                            .clipShape(.capsule)
                            .padding() // outer
                            .disabled(isLoading)
                        }
                        
                    }
                    else {
                        VStack{
                            HStack{
                                Button (action: { isEmptyAccount = true }) {
                                    Image(systemName: "person.fill")
                                        .accentColor(.gray)
                                }
                                .alert("Account Manager", isPresented: $isEmptyAccount) {
                                    
                                    Button(action: { isEmptyAccount = false }) {
                                        Text("Ok")
                                    }
                                } message: {
                                    Text("No previous Account found")
                                }
                                TextField(text: $registerUsernameInput) {
                                    Text("username")
                                        .foregroundStyle(Color("ThemedText").opacity(0.25))
                                }
                                .padding() // between text and border, inner spacing
                                .background(Color("Background"))
                                .clipShape(.capsule)
                                .foregroundStyle(Color("ThemedText"))
                            }
                            .padding(.horizontal) // outer spacing
                            HStack{
                                Button (action: { isEmptyAccount = true }) {
                                    Image(systemName: "mail")
                                        .accentColor(.gray)
                                }
                                .alert("Account Manager", isPresented: $isEmptyAccount) {
                                    
                                    Button(action: { isEmptyAccount = false }) {
                                        Text("Ok")
                                    }
                                } message: {
                                    Text("No previous Account found")
                                }
                                TextField(text: $registerEmailInput) {
                                    Text("email")
                                        .foregroundStyle(Color("ThemedText").opacity(0.25))
                                }
                                .padding() // between text and border, inner spacing
                                .background(Color("Background"))
                                .clipShape(.capsule)
                                .foregroundStyle(Color("ThemedText"))
                            }
                            .padding(.horizontal) // outer spacing
                            .padding(.vertical, 10)
                            
                            
                            //                        SecureField(text: $passwordInput) {
                            //                            Text("password")
                            //                                .foregroundStyle(Color("ThemedText").opacity(0.25))
                            //                        }
                            HStack{
                                if isSecured {
                                    SecureField("Password", text: $registerPasswordInput)
                                    //                                  .textFieldStyle(.roundedBorder)
                                        .textContentType(.password)
                                    //                                  .disableAutocorrection(true)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .padding() // between text and border, inner spacing
                                        .background(Color("Background"))
                                        .clipShape(.capsule)
                                        .foregroundStyle(Color("ThemedText"))
                                } else {
                                    TextField("Password", text: $registerPasswordInput)
                                        .textContentType(.password)
                                    //                                  .disableAutocorrection(true)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .padding() // between text and border, inner spacing
                                        .background(Color("Background"))
                                        .clipShape(.capsule)
                                        .foregroundStyle(Color("ThemedText"))
                                    
                                }
                                Button(action: { withAnimation { isSecured.toggle() } }) {
                                    Image(systemName: isSecured ? "eye.slash" : "eye")
                                        .accentColor(.gray)
                                }
                            }
                            .padding(.horizontal) // outer spacing
                            HStack{
                                if isSecured {
                                    SecureField("Confirm Password", text: $registerConfirmPasswordInput)
                                    //                                  .textFieldStyle(.roundedBorder)
                                        .textContentType(.password)
                                    //                                  .disableAutocorrection(true)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .padding() // between text and border, inner spacing
                                        .background(Color("Background"))
                                        .clipShape(.capsule)
                                        .foregroundStyle(Color("ThemedText"))
                                } else {
                                    TextField("Confirm Password", text: $registerConfirmPasswordInput)
                                        .textContentType(.password)
                                    //                                  .disableAutocorrection(true)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .padding() // between text and border, inner spacing
                                        .background(Color("Background"))
                                        .clipShape(.capsule)
                                        .foregroundStyle(Color("ThemedText"))
                                        .onSubmit {
                                            isLoading = true
                                            withAnimation {
                                                errorMessage = ""
                                            }
                                            register(username: registerUsernameInput, email: registerEmailInput, password: registerPasswordInput, confirmPassword: registerConfirmPasswordInput, errorMessage: $errorMessage, loadingController: $isLoading)
                                        }
                                    
                                }
                                Button(action: { withAnimation { isSecured.toggle() } }) {
                                    Image(systemName: isSecured ? "eye.slash" : "eye")
                                        .accentColor(.gray)
                                }
                            }
                            .padding(.horizontal) // outer spacing
                            .padding(.vertical, 10)
                            
                            if errorMessage != "" {
                                Text(errorMessage)
                                    .foregroundStyle(.red)
                                    .transition(.opacity)
                            }
                            Button(action: {
                                isLoading = true
                                withAnimation {
                                    errorMessage = ""
                                }
                                register(username: registerUsernameInput, email: registerEmailInput, password: registerPasswordInput, confirmPassword: registerConfirmPasswordInput, errorMessage: $errorMessage, loadingController: $isLoading)
                            }){
                                HStack{
                                    ZStack {
                                        if isLoading {
                                            ProgressView()
                                                .tint(.blue) // Matches label color
                                        } else {
                                            Image(systemName: "lock")
                                        }
                                    }
                                    Text("Register")
                                }
                            }
                            //                      .frame(maxWidth: .infinity)
                            .padding() // inner
                            .padding(.horizontal) // for a proper ratio among vertical and horizontal spacing
                            .background(.ultraThinMaterial)
                            .clipShape(.capsule)
                            .padding() // outer
                            .disabled(isLoading)
                        }
                    }
                    AuthSwitcher(auth: $authType)
                    Spacer()
                    
                    
                }
            }
        }
        //        Text("Page \(item)")
        //            .font(.title3)
        Spacer()
        
        if switchBinding<3 && switchBinding != 1 {
            Button(action: {
                if(switchBinding >= 3) {
                    withAnimation {
                        switchBinding = 0
                    }
                }
                else {
                    withAnimation {
                        switchBinding+=1
                    }
                }
            }) {
                Text("Onboard")
                    .font(.headline)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(.capsule)
            .padding(.bottom, 40)
            .transition(.opacity.combined(with: .opacity))
        }
    }
}


// 3. Main Onboarding Container
struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    @State public var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<4, id: \.self) { index in
                VStack{
                    Spacer()
                    OnboardingPageView(item: index, switchBinding: $currentPage)
                    if index == 3 {
                        Button(action: {
                            hasCompletedOnboarding = true
                        }) {
                            Spacer()
                            Text("Let's Start")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.ultraThinMaterial)
                                .foregroundColor(Color("ThemedText"))
                                .clipShape(.capsule)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 40)
                    }
                }
                .padding(.bottom)
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        
        //        TabView(selection: $currentPage) {
        //            ForEach(0..<4, id: \.self) { index in
        //                VStack {
        //                    OnboardingPageView(item: index, switchBinding: $currentPage)
        //
        //                    Spacer()
        //
        //                    // Show button only on the last page
        //                    if index == 4 - 1 {
        //                        Button(action: {
        //                            hasCompletedOnboarding = true
        //                        }) {
        //                            Text("Let's Start")
        //                                .font(.headline)
        //                                .frame(maxWidth: .infinity)
        //                                .padding()
        //                                .background(Color.accentColor)
        //                                .foregroundColor(.white)
        //                                .cornerRadius(10)
        //                                .padding(.horizontal)
        //                        }
        //                        .padding(.bottom, 40)
        //                    }
        //                }
        //                .tag(index)
        //            }
        //        }
    }
}
struct AuthSwitcher: View {
    @Binding var auth: authType
    var body: some View {
        HStack {
            if auth == .login {
                Text("Don't have an account?")
                Button(action: { withAnimation { auth = .register } }, label: {
                    Text("Register")
                })
            } else {
                Text ("Already have an account?")
                Button(action: { withAnimation { auth = .login } }, label: {
                    Text("Login")
                })
            }
        }
    }
}




class PersistenceController {
    static let shared = PersistenceController()
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


struct sessionResponse: Codable {
    var token: String
}

struct loginCredential: Codable {
    var username: String
    var password: String
}

struct registerCredential: Codable {
    var username: String
    var email: String
    var password: String
}

struct Token: Codable {
    var token: String
}

public func login(username: String, password: String, errorMessage: Binding<String>, loadingController: Binding<Bool>, loginState: Binding<Int>) {
    Task {
        do {
            try await sessionLogin(username: username, password: password, errorMessage: errorMessage, loginState: loginState)
            loadingController.wrappedValue = false
        } catch {
            print("Login Failed: ", error)
            loadingController.wrappedValue = false
        }
    }
}

func isValidEmail (email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

public func register(username: String, email: String, password: String, confirmPassword: String, errorMessage: Binding<String>, loadingController: Binding<Bool>) {
    Task {
        do {
            if (password != confirmPassword || password.count < 8) {
                errorMessage.wrappedValue = "Password and Confirm password must match"
            } else if username.count < 6 {
                errorMessage.wrappedValue = "Username cant be shorter than 6 characters"
            } else if !isValidEmail(email: email) {
                errorMessage.wrappedValue = "Invalid Email"
            }
            else {
                errorMessage.wrappedValue = ""
                try await sessionRegister(username: username, email: email, password: password, errorMessage: errorMessage)
            }
            loadingController.wrappedValue = false
        } catch {
            loadingController.wrappedValue = false // fallback
            print("Login Failed: ", error)
            loadingController.wrappedValue = false // fallback
        }
    }
}

//func sessionLogin(username: String, password: String) async throws {
//    let url = URL(string: "https://mess-backend-qseb.onrender.com/auth/login")!
//    //    let (data, _) = try await URLSession.shared.data(from: url)
//    //    print("raw login response: ", data)
//    //    return try JSONDecoder().decode(sessionResponse.self, from: data)
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//    let user = loginCredential(username: username, password: password)
//    
//    do {
//        let jsonData = try JSONEncoder().encode(user)
//        request.httpBody = jsonData
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        print("initializing request for login!!")
//        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
//            print("Request sent!, response: \(String(describing: String(data: data, encoding: .utf8))) ")
//        }
//        print("request ended !!")
//    } catch {
//        print("Error login POST: \(error)")
//    }
//}
@MainActor
func sessionLogin(username: String, password: String, errorMessage: Binding<String>, loginState: Binding<Int>) async throws {
    if username.count < 6 || password.count < 8 {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(0.5))
        } else {
            try await Task.sleep(nanoseconds: UInt64(0.5) * 1_000_000_000) // nanoseconds
        }
        withAnimation {
            errorMessage.wrappedValue = "Invalid Credentials"
        }
        return;
    }
    let url = URL(string: "https://mess-backend-qseb.onrender.com/auth/login")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let user = loginCredential(username: username, password: password)
    let jsonData = try JSONEncoder().encode(user)
    request.httpBody = jsonData
    
    print("initializing request for login!!")
    
    do {
        // The network call happens here
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("request ended !!")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            errorMessage.wrappedValue = "Invalid response from Server"
            print("Error: Not a valid HTTP response")
            withAnimation{
                loginState.wrappedValue = 2
            }
            return
        }
        
        print("Status Code: \(httpResponse.statusCode)")
        
        if (200...299).contains(httpResponse.statusCode) {
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
                withAnimation {
                    loginState.wrappedValue = 0
                }
                let tokenObject = try JSONDecoder().decode(Token.self, from: data)
                let context = PersistenceController.shared.container.viewContext
                var newtoken = Token(token: tokenObject.token)
                newtoken.token = tokenObject.token
                
                do {
                    try context.save()
                    print("saved token to CoreData")
                } catch {
                    print("failed saving to CoreData: ", error)
                }
                
            }
        } else {
            let finalError = try JSONDecoder().decode(String.self, from: data)
//            let serverError = String(data: data, encoding: .utf8) ?? "Unknown server error"
            withAnimation {
                errorMessage.wrappedValue = finalError
                loginState.wrappedValue = 2
            }
            print("Server returned an error status. Response: \(String(data: data, encoding: .utf8) ?? "")")
        }
        
    } catch {
        // This will now catch and print the exact network/timeout error
        print("Network request failed with error: \(error)")
        errorMessage.wrappedValue = "Server unreachable"
        withAnimation {
            loginState.wrappedValue = 2
        }
        throw error // Propagate the error up since the function is marked 'throws'
    }
}


@MainActor
func sessionRegister(username: String, email: String, password: String, errorMessage: Binding<String>) async throws {
    let url = URL(string: "https://mess-backend-qseb.onrender.com/auth/register")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let user = registerCredential(username: username, email: email, password: password)
    let jsonData = try JSONEncoder().encode(user)
    request.httpBody = jsonData
    
    print("initializing request for register!!")
    
    do {
        // The network call happens here
        let (data, response) = try await URLSession.shared.data(for: request)
        
//        print("request ended !!")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            errorMessage.wrappedValue = "Invalid response from Server"
            print("Error: Not a valid HTTP response")
            return
        }
        
        print("Status Code: \(httpResponse.statusCode)")
        
        if (200...299).contains(httpResponse.statusCode) {
            if let responseString = String(data: data, encoding: .utf8) {
                errorMessage.wrappedValue = "\(String(describing: String(data: data, encoding: .utf8)))"
                print("Response Body: \(responseString)")
            }
        } else {
            let finalError = try JSONDecoder().decode(String.self, from: data)
//            let serverError = String(data: data, encoding: .utf8) ?? "Unknown server error"
            withAnimation {
                errorMessage.wrappedValue = finalError
            }
            print("Server returned an error status. Response: \(String(data: data, encoding: .utf8) ?? "")")
        }
        
    } catch {
        // This will now catch and print the exact network/timeout error
        print("Network request failed with error: \(error)")
        errorMessage.wrappedValue = "Server unreachable"
        throw error // Propagate the error up since the function is marked 'throws'
    }
}
#Preview {
    OnboardingView()
}
