//
//  AuthService.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Foundation

struct User {
    var token: String
}

final class CurrentUser: ObservableObject {
    static let shared = CurrentUser()
    
    @Published private(set) var user: User?
    @Published private(set) var isSignedIn: Bool = false
    
    func setCurrentUser(_ user: User) {
        self.user = user
        self.isSignedIn = true
    }
    
    func clearUser() {
        self.user = nil
        self.isSignedIn = false
    }
}

class AuthService {
    static let shared = AuthService()
    private let serviceClient: ServiceClient = .init()
    private let userState: CurrentUser = .shared
    
    private let signInEndpoint = "signin"
    private let signOutEndpoint = "signout"
    
    func signIn(username: String, password: String) async throws {
        let request = SignInRequest(username: username, password: password)
        let response: SignInResponse = try await serviceClient.performRequest(
            endpoint: signInEndpoint,
            method: .POST,
            body: request
        )
        
        let user = User(token: response.token)
        
        Task { @MainActor in
            userState.setCurrentUser(user)
        }
    }
    
    func expressSignIn() async throws {
        try await signIn(username: "john", password: "12345")
    }
    
    func signOut() async throws {
        guard let user = userState.user else { return }
        try await serviceClient.performRequest(
            endpoint: signOutEndpoint,
            method: .POST,
            authToken: user.token
        )
        
        Task { @MainActor in
            userState.clearUser()
        }
    }
}
