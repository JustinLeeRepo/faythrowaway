//
//  AppointmentService.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Foundation

class AppointmentService {
    static let shared = AppointmentService()
    private let serviceClient: ServiceClient = .init()
    private let userState: CurrentUser = .shared
    
    private let appointmentListEndpoint = "appointments"
    
    func fetchAppointments() async throws -> [Appointment] {
        guard let user = userState.user else { throw ServiceError.unauthorized }
        
        let token = user.token
        let response: AppointmentsResponse = try await serviceClient.performRequest(
            endpoint: appointmentListEndpoint,
            method: .GET,
            authToken: token
        )

        return response.appointments
    }
}
