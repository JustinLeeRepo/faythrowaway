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

extension Appointment {
    public static let mockList: [Appointment] = mockUpcomingList + mockPastList
    
    public static let mockUpcoming: Appointment = mockUpcomingList[0]
    public static let mockUpcomingList: [Appointment] = [
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
    
    public static let mockPast: Appointment = mockPastList[0]
    public static let mockPastList: [Appointment] = [
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
        )
    ]
}
