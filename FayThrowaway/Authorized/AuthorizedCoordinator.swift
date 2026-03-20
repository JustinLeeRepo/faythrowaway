//
//  AuthorizedCoordinator.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import DependencyContainer

class AuthorizedCoordinator: ObservableObject {
    enum Tab: UInt {
        case first
        case second
        case third
        case fourth
    }
    @Published var tab: Tab = .first
    
    let appointmentsViewModel: AppointmentsViewModel
    
    init(dependencyContainer: DependencyContainable) {
        self.appointmentsViewModel = AppointmentsViewModel(dependencyContainer: dependencyContainer)
    }
}
