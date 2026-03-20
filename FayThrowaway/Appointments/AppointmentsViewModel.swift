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
    private let appointmentEventPub: PassthroughSubject<AppointmentEvent, Never>
    private let appointmentTabEventPublisher: PassthroughSubject<AppointmentTabEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencyContainer: DependencyContainable) {
        
        let appointmentEventPub = PassthroughSubject<AppointmentEvent, Never>()
        self.appointmentEventPub = appointmentEventPub
        
        let appointmentTabEventPublisher = PassthroughSubject<AppointmentTabEvent, Never>()
        self.appointmentTabEventPublisher = appointmentTabEventPublisher
        
        self.appointmentsHeaderViewModel = AppointmentsHeaderViewModel(appointmentEventPub: appointmentEventPub)
        self.appointmentListViewModel = AppointmentListViewModel(dependencyContainer: dependencyContainer, appointmentTabEventPublisher: appointmentTabEventPublisher, eventPublisher: appointmentEventPub)
        self.appointmentsTabViewModel = AppointmentsTabViewModel(eventPublisher: appointmentTabEventPublisher)
        
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
