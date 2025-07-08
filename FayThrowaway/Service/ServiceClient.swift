//
//  ServiceClient.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

enum ServiceError: Error, LocalizedError {
    case invalidURL
    case noData
    case unauthorized
    case serverError(Int)
    case decodingError
    case encodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .encodingError:
            return "Failed to encode request"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class ServiceClient {
    private let baseURL = "https://node-api-for-candidates.onrender.com"
    private let session: URLSession = .shared
    
    func performRequest<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        body: Codable? = nil,
        authToken: String? = nil
    ) async throws -> T {
        let request = try createRequest(endpoint: endpoint,
                                    method: method,
                                    body: body,
                                    authToken: authToken)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            try validateResponse(response: response)
            
            return try decodeData(data: data)
            
        } catch let error as ServiceError {
            throw error
        } catch {
            throw ServiceError.networkError(error)
        }
    }
    
    func performRequest(
        endpoint: String,
        method: HTTPMethod,
        body: Codable? = nil,
        authToken: String? = nil
    ) async throws {
        let request = try createRequest(endpoint: endpoint,
                                    method: method,
                                    body: body,
                                    authToken: authToken)
        
        do {
            let (_, response) = try await session.data(for: request)
            
            try validateResponse(response: response)
            
        } catch let error as ServiceError {
            throw error
        } catch {
            throw ServiceError.networkError(error)
        }
    }
    
    private func createRequest(
        endpoint: String,
        method: HTTPMethod,
        body: Codable? = nil,
        authToken: String? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw ServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let body {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(body)
            } catch {
                throw ServiceError.encodingError
            }
        }
        
        return request
    }
    
    private func validateResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.networkError(URLError(.badServerResponse))
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw ServiceError.unauthorized
        default:
            throw ServiceError.serverError(httpResponse.statusCode)
        }
    }
    
    private func decodeData<T: Codable>(
        data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
        nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw
    ) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = keyDecodingStrategy
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.dataDecodingStrategy = dataDecodingStrategy
            decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
            
            let result = try decoder.decode(T.self, from: data)
            return result
        }
        catch {
            throw ServiceError.decodingError
        }
    }
}
