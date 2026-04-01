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

public class UnauthorizedCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    let unauthorizedViewModel: UnauthorizedViewModel
    let signInViewModel: SignInViewModel
    
    private let unauthorizedEventPublisher: AnyPublisher<UnauthorizedEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    public init(dependencyContainer: DependencyContainable) {
        let unauthorizedEventSubject = PassthroughSubject<UnauthorizedEvent, Never>()
        
        self.unauthorizedEventPublisher = unauthorizedEventSubject.eraseToAnyPublisher()
        self.unauthorizedViewModel = UnauthorizedViewModel(dependencyContainer: dependencyContainer, unauthorizedEventSubject: unauthorizedEventSubject)
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
