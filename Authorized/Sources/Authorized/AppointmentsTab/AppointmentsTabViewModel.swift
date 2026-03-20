//
//  AppointmentsTabViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine

enum AppointmentTab: String {
    case upcoming = "Upcoming"
    case past = "Past"
}

class AppointmentsTabViewModel: ObservableObject {
    @Published var selectedTab: AppointmentTab = .upcoming
    
    private let appointmentTabEventPublisher: PassthroughSubject<AppointmentTabEvent, Never>
    
    init(eventPublisher: PassthroughSubject<AppointmentTabEvent, Never>) {
        self.appointmentTabEventPublisher = eventPublisher
    }
    
    func switchTab() {
        appointmentTabEventPublisher.send(.selectedTab(selectedTab))
    }
}
