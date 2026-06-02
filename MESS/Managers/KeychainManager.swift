//
//  KeychainManager.swift
//  MESS
//
//  Created by khush on 19/05/2026.
//

import Foundation
import Security
import JWTDecode

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    // MARK: SAVE
    func saveToken(token: String) {
        let data = Data(token.utf8)
        
        // delete old token first
        deleteToken()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecValueData as String: data
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print(token)
            print("token saved to keychain")
        } else {
            print("failed saving token:", status)
        }
    }
    // MARK: GET
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            if let data = item as? Data,
               let token = String(data: data, encoding: .utf8) {
                return token
            }
        }
        return nil
    }
    // MARK: DELETE
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken"
        ]
        SecItemDelete(query as CFDictionary)
    }
    struct userPayload: Codable {
        var username: String
        var email: String
        var profile: String?
    }
    func getUserInfo() -> userPayload? {
        do {
            let token = getToken()
            var tokenData: any JWT
            if token != nil {
                tokenData = try decode(jwt: token!)
                
                let data = try JSONSerialization.data(
                    withJSONObject: tokenData.body
                )
                let user = try JSONDecoder().decode(
                    userPayload.self,
                    from: data
                )
                return user;
            }
        }
        catch {
            print(error)
        }
        return nil ;
    }
    
    func refreshToken() async throws {
        let url = URL(string: "https://mess-backend-qseb.onrender.com/auth/refresh")!
        let token = getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(token!)",
               forHTTPHeaderField: "Authorization"
           )
        print("Bearer \(token!)")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("request ended !!")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Not a valid HTTP response")
                return
            }
            print("Status Code: \(httpResponse.statusCode)")
            if (200...299).contains(httpResponse.statusCode) {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseString)")
                }
                let tokenObject = try JSONDecoder().decode(Token.self, from: data)
                KeychainManager.shared.saveToken(token: tokenObject.token)
                print("New token saved to keychain")
            } else {
                print("Server returned an error status. Response: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }
    }
    
}
