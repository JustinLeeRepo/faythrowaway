//
//  AppointmentCardViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import Foundation

class AppointmentCardViewModel: ObservableObject {
    let appointment: Appointment
    let timeFormatter: DateFormatter
    let monthAbbreviator: DateFormatter
    let isNextUpcoming: Bool
    
    private let greatSuccessEventPub: PassthroughSubject<GreatSuccessEvent, Never>
    
    init(appointment: Appointment,
         timeFormatter: DateFormatter,
         monthAbbreviator: DateFormatter,
         isNextUpcoming: Bool = false,
         greatSuccessEventPub: PassthroughSubject<GreatSuccessEvent, Never>) {
        self.appointment = appointment
        self.timeFormatter = timeFormatter
        self.monthAbbreviator = monthAbbreviator
        self.isNextUpcoming = isNextUpcoming
        self.greatSuccessEventPub = greatSuccessEventPub
    }
    
    var startDate: Date? {
        return ISO8601DateFormatter().date(from: appointment.start)
    }
    
    var endDate: Date? {
        return ISO8601DateFormatter().date(from: appointment.end)
    }
    
    var monthAbbreviation: String? {
        guard let startDate = startDate else { return nil }
        
        return monthAbbreviator.string(from: startDate).uppercased()
    }
    
    var dateDay: Int? {
        guard let startDate = startDate else { return nil }
        
        return Calendar.current.component(.day, from: startDate)
    }
    
    var isUpcomming: Bool {
        return appointment.isUpcoming
    }
    
    var timeTitle: String {
        if isNextUpcoming,
           let startDate = startDate,
           let endDate = endDate {
            return "\(timeFormatter.string(from: startDate)) - \(timeFormatter.string(from: endDate)) (PT)"
        }
        
        if let startDate = startDate {
            return timeFormatter.string(from: startDate)
        }
        
        return appointment.start
    }
    
    var typeTitle: String {
        isNextUpcoming ? "\(appointment.appointmentType.rawValue) with \(appointment.providerName), \(appointment.providerType)" : appointment.appointmentType.rawValue
    }
    
    func greatSuccess() {
        self.greatSuccessEventPub.send(.greatSuccess)
    }
}
