//
//  AppointmentsViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import DependencyContainer

enum AppointmentTabEvent {
    case selectedTab(AppointmentTab)
}

enum AppointmentEvent {
    case joinMeeting
    case createMeeting
}

class AppointmentsViewModel: ObservableObject {
    @Published var joinMeeting: Bool = false
    @Published var createMeeting: Bool = false
    
    let appointmentsHeaderViewModel: AppointmentsHeaderViewModel
    let appointmentListViewModel: AppointmentListViewModel
    let appointmentsTabViewModel: AppointmentsTabViewModel
    private let appointmentEventPub: AnyPublisher<AppointmentEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencyContainer: DependencyContainable) {
        
        let appointmentEventSubject = PassthroughSubject<AppointmentEvent, Never>()
        let appointmentEventPublisher = appointmentEventSubject.eraseToAnyPublisher()
        self.appointmentEventPub = appointmentEventPublisher
        
        let appointmentTabEventSubject = PassthroughSubject<AppointmentTabEvent, Never>()
        let appointmentTabEventPublisher = appointmentTabEventSubject.eraseToAnyPublisher()
        
        self.appointmentsHeaderViewModel = AppointmentsHeaderViewModel(appointmentEventSubject: appointmentEventSubject)
        self.appointmentListViewModel = AppointmentListViewModel(dependencyContainer: dependencyContainer, appointmentTabEventPublisher: appointmentTabEventPublisher, eventSubject: appointmentEventSubject)
        self.appointmentsTabViewModel = AppointmentsTabViewModel(eventSubject: appointmentTabEventSubject)
        
        setupListener()
    }
    
    private func setupListener() {
        appointmentEventPub
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
    }
    
    private func handleNavigationEvent(_ event: AppointmentEvent) {
        switch event {
        case .joinMeeting:
            Task { @MainActor in
                self.joinMeeting = true
            }
            break
            
        case .createMeeting:
            Task { @MainActor in
                self.createMeeting = true
            }
            break
        }
    }
}
