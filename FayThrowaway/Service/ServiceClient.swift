//
//  ServiceClient.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Foundation

struct SignInRequest: Codable {
    let username: String
    let password: String
}

struct SignInResponse: Codable {
    let token: String
}

enum SignInServiceError: Error, LocalizedError {
    case invalidURL
    case noData
    case unauthorized
    case serverError(Int)
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .unauthorized:
            return "Invalid username or password"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class ServiceClient {
    private let baseURL = "https://node-api-for-candidates.onrender.com"
    private let session: URLSession = .shared
    
    func signIn(username: String, password: String) async throws -> SignInResponse {
        guard let url = URL(string: "\(baseURL)/signin") else {
            throw SignInServiceError.invalidURL
        }
        
        let request = SignInRequest(username: username, password: password)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw SignInServiceError.networkError(error)
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw SignInServiceError.networkError(URLError(.badServerResponse))
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let signInResponse = try JSONDecoder().decode(SignInResponse.self, from: data)
                    return signInResponse
                } catch {
                    throw SignInServiceError.decodingError
                }
            case 401:
                throw SignInServiceError.unauthorized
            default:
                throw SignInServiceError.serverError(httpResponse.statusCode)
            }
            
        } catch let error as SignInServiceError {
            throw error
        } catch {
            throw SignInServiceError.networkError(error)
        }
    }
    
    func signOut() async throws {
        //TODO: revoke token API
    }
}
