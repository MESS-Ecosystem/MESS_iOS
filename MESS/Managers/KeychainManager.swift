//
//  KeychainManager.swift
//  MESS
//
//  Created by khush on 19/05/2026.
//

import Foundation
import Security

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
}
