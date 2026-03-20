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

public enum AppointmentType: String, Codable {
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

public struct Appointment: Codable, Identifiable {
    public var id: String {
        appointmentId
    }
                            
    public var providerName: String {
        "Jane Williams"
    }
    
    public var providerType: String {
        "RD"
    }
    
    let appointmentId: String
    let patientId: String
    let providerId: String
    let status: AppointmentStatus
    public let appointmentType: AppointmentType
    public let start: Date
    public let end: Date
    let durationInMinutes: Int
    let recurrenceType: RecurrenceType
    
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
    
    public var isUpcoming: Bool {
        status == .scheduled
    }
    
    public var isPast: Bool {
        status == .occurred
    }
}
