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
    
    let user: User
    let appointmentsViewModel: AppointmentsViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        self.appointmentsViewModel = AppointmentsViewModel(user: user)
    }
}
