//
//  AppointmentListViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import DependencyContainer
import Foundation
import Services
import SwiftUI

class AppointmentListViewModel: ObservableObject {
    enum State {
        case empty
        case ready
    }
    
    var state: State {
        if !appointments.isEmpty || isLoading {
            return .ready
        }
        
        return .empty
    }
    
    @Published var isLoading = false
    @Published var appointments = [Appointment]()
    @Published var selectedTab: AppointmentTab = .upcoming
    @Published var error: Error?
    
    let dateFormatter: DateFormatter
    
    private let appointmentEventPub: PassthroughSubject<AppointmentEvent, Never>
    private let appointmentTabEventPublisher: PassthroughSubject<AppointmentTabEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    private let appointmentService: AppointmentServicable
    
    var currentAppointments: [Appointment] {
        if isLoading {
            return appointmentService.placeholderAppointments
        }
        return selectedTab == .upcoming ? upcomingAppointments : pastAppointments
    }
    
    private var upcomingAppointments: [Appointment] {
        appointments
            .filter { $0.isUpcoming }
    }
    
    private var pastAppointments: [Appointment] {
        appointments
            .filter { $0.isPast }
    }
    
    init(dependencyContainer: DependencyContainable,
        appointmentTabEventPublisher: PassthroughSubject<AppointmentTabEvent, Never>,
        eventPublisher: PassthroughSubject<AppointmentEvent, Never>) {
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeZone = .current
        
        self.appointmentTabEventPublisher = appointmentTabEventPublisher
        self.appointmentEventPub = eventPublisher
        
        self.appointmentService = dependencyContainer.getAppointmentService()
        setupListener()
    }
    
    func appointmentCardViewModel(appointment: Appointment, isFirst: Bool) -> AppointmentCardViewModel {
        AppointmentCardViewModel(appointment: appointment,
                                 dateFormatter: dateFormatter,
                                 isNextUpcoming: isFirst && appointment.isUpcoming,
                                 appointmentEventPub: appointmentEventPub)
    }
    
    @MainActor
    func fetchAppointments() async {
        withAnimation {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            let appointments = try await appointmentService.fetchAppointments()
            withAnimation {
                self.appointments = appointments
                self.isLoading = false
                self.error = nil
            }
        }
        catch {
            withAnimation {
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    private func setupListener() {
        appointmentTabEventPublisher
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
    }
    
    private func handleNavigationEvent(_ event: AppointmentTabEvent) {
        switch event {
        case .selectedTab(let tab):
            Task { @MainActor in
                self.selectedTab = tab
            }
            break
        }
    }

}
