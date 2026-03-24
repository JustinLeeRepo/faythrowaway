//
//  AppointmentService.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Foundation
import MilaNetwork

public protocol AppointmentServicable {
    var placeholderAppointments: [Appointment] { get }
    func fetchAppointments() async throws -> [Appointment]
}

struct AppointmentEndpoint: APIEndpoint {
    let token: String
    var base: String {
        Constants.API.baseURL
    }
    
    var path: String {
        "appointments"
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var body: Encodable? {
        return nil
    }
    
    var authToken: String? {
        return token
    }
}

public class AppointmentService: AppointmentServicable {
    private let networkService: NetworkServiceProtocol
    private let userStore: UserStorable

    public var placeholderAppointments: [Appointment] {
        Appointment.mockList
    }
    
    public init(networkService: NetworkServiceProtocol, userStore: UserStorable) {
        self.networkService = networkService
        self.userStore = userStore
    }
    
    public func fetchAppointments() async throws -> [Appointment] {
        guard let user = userStore.getCurrentUser() else { throw ServiceError.unauthorized }
        
        let endpoint = AppointmentEndpoint(token: user.token)
        let response: AppointmentsResponse = try await networkService.performRequest(endpoint)

        return response.appointments
    }
}

public class MockAppointmentService: AppointmentServicable {
    public init() {}
    public var shouldThrow = false
    public var placeholderAppointments: [Appointment] {
        Appointment.mockList
    }
    
    public func fetchAppointments() async throws -> [Appointment] {
        guard !shouldThrow else { throw ServiceError.unauthorized }
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return Appointment.mockList
    }
}
