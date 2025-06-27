//
//  AppointmentsViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine

enum AppointmentTabEvent {
    case selectedTab(AppointmentTab)
}

class AppointmentsViewModel: ObservableObject {
    let user: User
    
    let appointmentListViewModel: AppointmentListViewModel
    let appointmentsTabViewModel: AppointmentsTabViewModel
    private let appointmentTabEventPublisher: PassthroughSubject<AppointmentTabEvent, Never>
    
    init(user: User) {
        self.user = user
        let appointmentTabEventPublisher = PassthroughSubject<AppointmentTabEvent, Never>()
        self.appointmentTabEventPublisher = appointmentTabEventPublisher
        
        self.appointmentListViewModel = AppointmentListViewModel(user: user, eventPublisher: appointmentTabEventPublisher)
        self.appointmentsTabViewModel = AppointmentsTabViewModel(eventPublisher: appointmentTabEventPublisher)
        
    }
}
