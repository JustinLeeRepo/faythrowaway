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
    
    private let appointmentTabEventSubject: PassthroughSubject<AppointmentTabEvent, Never>
    
    init(eventSubject: PassthroughSubject<AppointmentTabEvent, Never>) {
        self.appointmentTabEventSubject = eventSubject
    }
    
    func switchTab() {
        appointmentTabEventSubject.send(.selectedTab(selectedTab))
    }
}
