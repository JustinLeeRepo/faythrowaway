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

class AppointmentService: AppointmentServicable {
    private let networkService: NetworkServiceProtocol
    private let userStore: UserStorable

    var placeholderAppointments: [Appointment] {
        Array(mockAppointments[0..<3])
    }
    
    init(networkService: NetworkServiceProtocol, userStore: UserStorable) {
        self.networkService = networkService
        self.userStore = userStore
    }
    
    func fetchAppointments() async throws -> [Appointment] {
        guard let user = userStore.getCurrentUser() else { throw ServiceError.unauthorized }
        
        let endpoint = AppointmentEndpoint(token: user.token)
        let response: AppointmentsResponse = try await networkService.performRequest(endpoint)

        return response.appointments
    }
}

class MockAppointmentService: AppointmentServicable {
    var placeholderAppointments: [Appointment] {
        Array(mockAppointments[0..<3])
    }
    
    func fetchAppointments() async throws -> [Appointment] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return mockAppointments
    }
}

var mockAppointments = [
    Appointment(
        appointmentId: "appt_1",
        patientId: "patient_1",
        providerId: "provider_1",
        status: .scheduled,
        appointmentType: .initialConsultation,
        start: Date().addingTimeInterval(60 * 60 * 24),
        end: Date().addingTimeInterval(60 * 60 * 25),
        durationInMinutes: 60,
        recurrenceType: .weekly
    ),
    Appointment(
        appointmentId: "appt_2",
        patientId: "patient_1",
        providerId: "provider_2",
        status: .scheduled,
        appointmentType: .followUp,
        start: Date().addingTimeInterval(60 * 60 * 48),
        end: Date().addingTimeInterval(60 * 60 * 49),
        durationInMinutes: 60,
        recurrenceType: .monthly
    ),
    Appointment(
        appointmentId: "appt_3",
        patientId: "patient_1",
        providerId: "provider_1",
        status: .occurred,
        appointmentType: .initialConsultation,
        start: Date().addingTimeInterval(-60 * 60 * 24 * 3),
        end: Date().addingTimeInterval(-60 * 60 * 24 * 3 + 3600),
        durationInMinutes: 60,
        recurrenceType: .weekly
    ),
    Appointment(
        appointmentId: "appt_4",
        patientId: "patient_2",
        providerId: "provider_3",
        status: .occurred,
        appointmentType: .followUp,
        start: Date().addingTimeInterval(-60 * 60 * 24 * 7),
        end: Date().addingTimeInterval(-60 * 60 * 24 * 7 + 1800),
        durationInMinutes: 30,
        recurrenceType: .monthly
    ),
    Appointment(
        appointmentId: "appt_5",
        patientId: "patient_3",
        providerId: "provider_2",
        status: .scheduled,
        appointmentType: .followUp,
        start: Date().addingTimeInterval(60 * 60 * 6),
        end: Date().addingTimeInterval(60 * 60 * 7),
        durationInMinutes: 60,
        recurrenceType: .weekly
    )
]
