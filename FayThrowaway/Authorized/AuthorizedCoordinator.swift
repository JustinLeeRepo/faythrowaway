//
//  AuthorizedCoordinator.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine

class AuthorizedCoordinator: ObservableObject {
    enum Tab: UInt {
        case first
        case second
        case third
        case fourth
    }
    @Published var tab: Tab = .first
    
    let appointmentsViewModel: AppointmentsViewModel
    private let authService: AuthServicable
    
    init(dependencyContainer: DependencyContainable) {
        self.appointmentsViewModel = AppointmentsViewModel(dependencyContainer: dependencyContainer)
        self.authService = dependencyContainer.getAuthService()
    }
}
