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
    
    func fetchAppointments(token: String) async throws -> [Appointment] {
        let response = try await serviceClient.getAppointments(token: token)
        return response.appointments
    }
}
