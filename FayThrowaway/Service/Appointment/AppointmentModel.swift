//
//  AppointmentModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 7/7/25.
//

import Foundation

enum AppointmentStatus: String, Codable {
    case scheduled = "Scheduled"
    case occurred = "Occurred"
}

enum AppointmentType: String, Codable {
    case followUp = "Follow-up"
    case initialConsultation = "Initial consultation"
}

enum RecurrenceType: String, Codable {
    case weekly = "Weekly"
    case monthly = "Monthly"
}


struct AppointmentsResponse: Codable {
    let appointments: [Appointment]
}

struct Appointment: Codable, Identifiable {
    var id: String {
        appointmentId
    }
                            
    var providerName: String {
        "Jane Williams"
    }
    
    var providerType: String {
        "RD"
    }
    
    let appointmentId: String
    let patientId: String
    let providerId: String
    let status: AppointmentStatus
    let appointmentType: AppointmentType
    // do conversion from string to date in viewModel or in decoder
    // decoder.dateDecodingStrategy = .iso8601
    let start: String
    let end: String
    let durationInMinutes: Int
    let recurrenceType: RecurrenceType
    
    // do conversion from snakcase here or in decoder
    // decoder.keyDecodingStrategy = .convertFromSnakeCase
    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case patientId = "patient_id"
        case providerId = "provider_id"
        case status
        case appointmentType = "appointment_type"
        case start
        case end
        case durationInMinutes = "duration_in_minutes"
        case recurrenceType = "recurrence_type"
    }
    
    var isUpcoming: Bool {
        status == .scheduled
    }
    
    var isPast: Bool {
        status == .occurred
    }
}

enum AppointmentsServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError
    case unauthorized
    case serverError(Int)
}
