//
//  AppointmentListViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import Foundation

class AppointmentListViewModel: ObservableObject {
    @Published var appointments = [Appointment]()
    @Published var selectedTab: AppointmentTab = .upcoming
    @Published var error: Error?
    
    let user: User
    let timeFormatter: DateFormatter
    let monthAbbreviator: DateFormatter
    
    
    private let appointmentTabEventPublisher: PassthroughSubject<AppointmentTabEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    private let appointmentService: AppointmentService = .shared
    
    var upcomingAppointments: [Appointment] {
        appointments
            .filter { $0.isUpcoming }
    }
    
    var pastAppointments: [Appointment] {
        appointments
            .filter { $0.isPast }
    }
    
    //TODO: add listener that will switch selectedTab
    var currentAppointments: [Appointment] {
        selectedTab == .upcoming ? upcomingAppointments : pastAppointments
    }
    
    init(user: User, eventPublisher: PassthroughSubject<AppointmentTabEvent, Never>) {
        self.user = user
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        self.timeFormatter = timeFormatter
        
        let monthAbbreviator = DateFormatter()
        monthAbbreviator.dateFormat = "MMM"
        self.monthAbbreviator = monthAbbreviator
        
        self.appointmentTabEventPublisher = eventPublisher
        setupListener()
        
        Task {
            await fetchAppointments()
        }
    }
    
    func appointmentCardViewModel(appointment: Appointment, isFirst: Bool) -> AppointmentCardViewModel {
        AppointmentCardViewModel(appointment: appointment,
                                 timeFormatter: timeFormatter,
                                 monthAbbreviator: monthAbbreviator,
                                 isNextUpcoming: isFirst && selectedTab == .upcoming)
    }
    
    func fetchAppointments() async {
        do {
            let appointments = try await appointmentService.fetchAppointments(token: user.token)
            Task { @MainActor in
                self.appointments = appointments
            }
        }
        catch {
            Task { @MainActor in
                self.error = error
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
