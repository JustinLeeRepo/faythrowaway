//
//  AppointmentCardViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import Foundation
import Services

class AppointmentCardViewModel {
    let appointment: Appointment
    let dateFormatter: DateFormatter
    let isNextUpcoming: Bool
    
    private let appointmentEventPub: PassthroughSubject<AppointmentEvent, Never>
    
    init(appointment: Appointment,
         dateFormatter: DateFormatter,
         isNextUpcoming: Bool = false,
         appointmentEventPub: PassthroughSubject<AppointmentEvent, Never>) {
        self.appointment = appointment
        self.dateFormatter = dateFormatter
        self.isNextUpcoming = isNextUpcoming
        self.appointmentEventPub = appointmentEventPub
    }
    
    private var startDate: Date {
        appointment.start
    }
    
    private var endDate: Date {
        appointment.end
    }
    
    var monthAbbreviation: String {
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: startDate).uppercased()
    }
    
    var dateDay: Int {
        return Calendar.current.component(.day, from: startDate)
    }
    
    private var isUpcomming: Bool {
        return appointment.isUpcoming
    }
    
    var timeTitle: String {
        if isNextUpcoming {
            dateFormatter.dateFormat = "h:mm a"
            let startTime = dateFormatter.string(from: startDate)
            let endTime = dateFormatter.string(from: endDate)
            
            dateFormatter.dateFormat = "z"
            let timeZone = dateFormatter.string(from: endDate)
            return "\(startTime) - \(endTime) (\(timeZone))"
        }
        
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: startDate)
    }
    
    var typeTitle: String {
        let appointmentType = appointment.appointmentType.rawValue
        if isNextUpcoming {
            let providerName = appointment.providerName
            let providerType = appointment.providerType
            return "\(appointmentType) with \(providerName), \(providerType)"
        }
        
        return appointmentType
    }
    
    func joinMeeting() {
        self.appointmentEventPub.send(.joinMeeting)
    }
}
