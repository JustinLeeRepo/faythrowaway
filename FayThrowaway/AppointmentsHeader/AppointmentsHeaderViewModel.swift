//
//  AppointmentsHeaderViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine

class AppointmentsHeaderViewModel {
    private let appointmentEventPub: PassthroughSubject<AppointmentEvent, Never>
    
    init(appointmentEventPub: PassthroughSubject<AppointmentEvent, Never>) {
        self.appointmentEventPub = appointmentEventPub
    }
    
    func createMeeting() {
        appointmentEventPub.send(.createMeeting)
    }
}
