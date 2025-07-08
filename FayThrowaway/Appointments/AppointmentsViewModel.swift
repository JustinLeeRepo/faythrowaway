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

enum GreatSuccessEvent {
    case greatSuccess
    case veryNice
}

class AppointmentsViewModel: ObservableObject {
    @Published var greatSuccess: Bool = false
    @Published var veryNice: Bool = false
    
    let appointmentsHeaderViewModel: AppointmentsHeaderViewModel
    let appointmentListViewModel: AppointmentListViewModel
    let appointmentsTabViewModel: AppointmentsTabViewModel
    private let greatSuccessEventPub: PassthroughSubject<GreatSuccessEvent, Never>
    private let appointmentTabEventPublisher: PassthroughSubject<AppointmentTabEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        let greatSuccessEventPub = PassthroughSubject<GreatSuccessEvent, Never>()
        self.greatSuccessEventPub = greatSuccessEventPub
        
        let appointmentTabEventPublisher = PassthroughSubject<AppointmentTabEvent, Never>()
        self.appointmentTabEventPublisher = appointmentTabEventPublisher
        
        self.appointmentsHeaderViewModel = AppointmentsHeaderViewModel(greatSuccessEventPub: greatSuccessEventPub)
        self.appointmentListViewModel = AppointmentListViewModel(appointmentTabEventPublisher: appointmentTabEventPublisher, eventPublisher: greatSuccessEventPub)
        self.appointmentsTabViewModel = AppointmentsTabViewModel(eventPublisher: appointmentTabEventPublisher)
        
        setupListener()
    }
    
    private func setupListener() {
        greatSuccessEventPub
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
    }
    
    private func handleNavigationEvent(_ event: GreatSuccessEvent) {
        switch event {
        case .greatSuccess:
            Task { @MainActor in
                self.greatSuccess = true
            }
            break
            
        case .veryNice:
            self.veryNice = true
            break
        }
    }
}
