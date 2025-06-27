//
//  UnauthorizedCoordinator.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import SwiftUI

enum UnauthorizedEvent {
    case proceedToSignIn
}

class UnauthorizedCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    let unauthorizedViewModel: UnauthorizedViewModel
    
    private let unauthorizedEventPublisher: PassthroughSubject<UnauthorizedEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let unauthorizedEventPublisher = PassthroughSubject<UnauthorizedEvent, Never>()
        
        self.unauthorizedEventPublisher = unauthorizedEventPublisher
        self.unauthorizedViewModel = UnauthorizedViewModel(unauthorizedEventPublisher: unauthorizedEventPublisher)
        
        setupListener()
    }
    
    func createSignInViewModel(model: SignInModel) -> SignInViewModel {
        return SignInViewModel(model: model)
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
            path.append(SignInModel())
            break
        }
    }
}
