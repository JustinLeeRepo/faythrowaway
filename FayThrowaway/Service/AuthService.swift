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

@MainActor
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
    
    func signIn(username: String, password: String) async throws {
        let response = try await serviceClient.signIn(username: username, password: password)
        // TODO: persist token ideally with TTL
        let user = User(token: response.token)
        
        Task { @MainActor in
            userState.setCurrentUser(user)
        }
    }
    
    func expressSignIn() async throws {
        try await signIn(username: "john", password: "12345")
    }
    
    func signOut() async throws {
        try await serviceClient.signOut()
        
        Task { @MainActor in
            userState.clearUser()
        }
    }
}
