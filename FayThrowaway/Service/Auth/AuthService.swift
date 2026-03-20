//
//  AuthService.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Foundation
import MilaNetwork
import MilaKeychain

public protocol AuthServicable {
    func signIn(username: String, password: String) async throws
    func expressSignIn() async throws
    func signOut() async throws
}

struct AuthEndpoint: APIEndpoint {
    enum Action {
        case signIn(SignInRequest)
        case signOut(String)
    }
    
    let action: Action
    
    var base: String {
        return Constants.API.baseURL
    }
    
    var path: String {
        switch action {
        case .signIn:
            return "signin"
        case .signOut:
            return "signout"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var method: HTTPMethod {
        .POST
    }
    
    var body: Encodable? {
        switch action {
        case .signIn(let request):
            return request
        case .signOut:
            return nil
        }
    }
    
    var authToken: String? {
        switch action {
        case .signIn:
            return nil
        case .signOut(let token):
            return token
        }
    }
}

public class AuthService: AuthServicable {
    private let networkService: NetworkServiceProtocol
    private let userStore: UserStorable
    private let keychain: Keychainable
    
    
    public init(networkService: NetworkServiceProtocol,
                userStore: UserStorable,
                keychain: Keychainable) {
        self.networkService = networkService
        self.userStore = userStore
        self.keychain = keychain
    }
    
    public func signIn(username: String, password: String) async throws {
        let request = SignInRequest(username: username, password: password)
        let endpoint = AuthEndpoint(action: .signIn(request))
        let response: SignInResponse = try await networkService.performRequest(endpoint)
        
        let user = User(token: response.token)
        try keychain.update(id: Constants.Keychain.authToken, stringData: response.token)
        userStore.setCurrentUser(user)
    }
    
    public func expressSignIn() async throws {
        try await signIn(username: "john", password: "12345")
    }
    
    public func signOut() async throws {
        guard let _ = userStore.getCurrentUser() else { throw ServiceError.unauthorized }
        try keychain.delete(id: Constants.Keychain.authToken)
        
//        let endpoint = AuthEndpoint(action: .signOut(user.token))
//        try await networkService.performRequest(endpoint)
        
        userStore.clearUser()
    }
}

class MockAuthService: AuthServicable {
    func signIn(username: String, password: String) async throws {
        Task {
            print("mock sign in")
        }
    }
    
    func expressSignIn() async throws {
        try await signIn(username: "", password: "")
    }
    
    func signOut() async throws {
        Task {
            print("mock sign out")
        }
    }
}
