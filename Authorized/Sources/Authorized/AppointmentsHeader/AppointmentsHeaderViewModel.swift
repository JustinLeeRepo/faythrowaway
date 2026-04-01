//
//  AppointmentsHeaderViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine

class AppointmentsHeaderViewModel {
    private let appointmentEventSubject: PassthroughSubject<AppointmentEvent, Never>
    
    init(appointmentEventSubject: PassthroughSubject<AppointmentEvent, Never>) {
        self.appointmentEventSubject = appointmentEventSubject
    }
    
    func createMeeting() {
        appointmentEventSubject.send(.createMeeting)
    }
}
