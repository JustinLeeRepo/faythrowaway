//
//  AppointmentsViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Foundation

class AppointmentsViewModel: ObservableObject {
    @Published var appointments = [Appointment]()
    @Published var error: Error?
    @Published var selectedTab = 0
    
    let user: User
    
    private let appointmentService: AppointmentService = .shared
    
    init(user: User) {
        self.user = user
        
        Task {
            await fetchAppointments()
        }
    }
    
    var upcomingAppointments: [Appointment] {
        appointments
            .filter { $0.isUpcoming }    }
    
    var pastAppointments: [Appointment] {
        appointments
            .filter { $0.isPast }
    }
    
    var currentAppointments: [Appointment] {
        selectedTab == 0 ? upcomingAppointments : pastAppointments
    }
    
    func fetchAppointments() async {
        do {
            let appointments = try await appointmentService.fetchAppointments(token: user.token)
            Task { @MainActor in
                self.appointments = appointments
            }
        }
        catch {
            self.error = error
        }
    }
}
