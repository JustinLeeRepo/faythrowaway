// The Swift Programming Language
// https://docs.swift.org/swift-book


import MilaKeychain
import MilaNetwork
import Services

public protocol DependencyContainable {
    func getAuthService() -> AuthServicable
    func getAppointmentService() -> AppointmentServicable
    func getUserStore() -> UserStorable
}

public class DependencyContainer: DependencyContainable {
    private let authService: AuthServicable
    private let appointmentService: AppointmentServicable
    private let keychain: Keychainable
    private let userStore: UserStorable
    private let networkService: NetworkServiceProtocol
    
    public static let shared = DependencyContainer()
    
    private init() {

        self.networkService = NetworkService()
        self.keychain = Keychain()
        self.userStore = UserStore(keychain: keychain)
        self.authService = AuthService(networkService: self.networkService, userStore: self.userStore, keychain: self.keychain)
        self.appointmentService = AppointmentService(networkService: networkService, userStore: userStore)
    }
    
    public func getAuthService() -> AuthServicable {
        return authService
    }
    
    public func getAppointmentService() -> AppointmentServicable {
        return appointmentService
    }
    
    public func getUserStore() -> UserStorable {
        return userStore
    }
}

public class MockDependencyContainer: DependencyContainable {
    public init() {}
    
    public func getUserStore() -> any UserStorable {
        MockUserStore()
    }
    
    public func getAuthService() -> AuthServicable {
        MockAuthService()
    }
    
    public func getAppointmentService() -> AppointmentServicable {
        MockAppointmentService()
    }
}
