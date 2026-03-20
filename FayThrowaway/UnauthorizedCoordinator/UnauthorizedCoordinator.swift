//
//  UnauthorizedCoordinator.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import DependencyContainer
import SwiftUI

enum UnauthorizedEvent {
    case proceedToSignIn
}

class UnauthorizedCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    let unauthorizedViewModel: UnauthorizedViewModel
    let signInViewModel: SignInViewModel
    
    private let unauthorizedEventPublisher: PassthroughSubject<UnauthorizedEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencyContainer: DependencyContainable) {
        let unauthorizedEventPublisher = PassthroughSubject<UnauthorizedEvent, Never>()
        
        self.unauthorizedEventPublisher = unauthorizedEventPublisher
        self.unauthorizedViewModel = UnauthorizedViewModel(dependencyContainer: dependencyContainer, unauthorizedEventPublisher: unauthorizedEventPublisher)
        self.signInViewModel = SignInViewModel(dependencyContainer: dependencyContainer)
        
        setupListener()
    }
    
    private func setupListener() {
        unauthorizedEventPublisher
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
    }
    
    private func handleNavigationEvent(_ event: UnauthorizedEvent) {
        switch event {
        case .proceedToSignIn:
            path.append(self.signInViewModel)
            break
        }
    }
}
