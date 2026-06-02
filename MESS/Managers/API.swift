//
//  API.swift
//  MESS
//
//  Created by khush on 01/06/2026.
//

import Foundation

class API {
    static func get <T: Decodable>(
        _ url: String,
        type: T.Type
    ) async throws -> T {
        let url = URL(string: url)!
        let token = KeychainManager.shared.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(token!)",
               forHTTPHeaderField: "Authorization"
           )
//        print("Bearer \(token!)")
        let (data, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse {
            print("Status:", http.statusCode)
        }

        print(String(data: data, encoding: .utf8) ?? "nil")
            
        return try JSONDecoder().decode(T.self, from: data)
    }
}


/// more like axios feel on swift, can call like:
/*
    let users = try await API.get("https://api.com/users", type: [User].self)
*/
