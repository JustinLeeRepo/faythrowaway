//
//  User.swift
//  FayThrowaway
//
//  Created by Justin Lee on 3/19/26.
//

import Combine
import MilaKeychain

public struct User {
    var token: String
}

public protocol UserStorable {
    func getCurrentUserPublisher() -> AnyPublisher<User?, Never>
    func getCurrentUser() -> User?
    func setCurrentUser(_ user: User)
    func clearUser()
}

//ObservableObject conformance instead of @Observable annotation
//because withObservationTracking is unreliable after first callback
public class UserStore: ObservableObject, UserStorable {
    @Published private(set) var user: User?
    
    private let keychain: Keychainable
    public init(keychain: Keychainable) {
        self.keychain = keychain
        initUser()
    }
    
    private func initUser() {
        if let token = try? keychain.get(id: Constants.Keychain.authToken) {
            let user = User(token: token)
            setCurrentUser(user)
        }
    }
    
    // Just(self.user).eraseToAnyPublisher only triggered on first change
    public func getCurrentUserPublisher() -> AnyPublisher<User?, Never> {
        $user.eraseToAnyPublisher()
    }
    
    public func getCurrentUser() -> User? {
        return self.user
    }
    
    public func setCurrentUser(_ user: User) {
        self.user = user
    }
    
    public func clearUser() {
        self.user = nil
    }
}

public class MockUserStore: ObservableObject, UserStorable {
    @Published public var mockUser: User? = User(token: "Mila")
    
    public func getCurrentUser() -> User? {
        return mockUser
    }
    
    public func getCurrentUserPublisher() -> AnyPublisher<User?, Never> {
        $mockUser.eraseToAnyPublisher()
    }
    
    public func setCurrentUser(_ user: User) {
        mockUser = user
    }
    
    public func clearUser() {
        mockUser = nil
    }
}
