//
//  RootCoordinator.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import DependencyContainer
import Services
import SwiftUI

@Observable
class RootCoordinator {
    enum State {
        case authorized(AuthorizedCoordinator)
        case unauthorized(UnauthorizedCoordinator)
    }
    
    var state: State {
        if let authorizedCoordinator = authorizedCoordinator {
            return .authorized(authorizedCoordinator)
        }
        
        return .unauthorized(unauthorizedCoordinator)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var authorizedCoordinator: AuthorizedCoordinator?
    private let unauthorizedCoordinator: UnauthorizedCoordinator
    private let dependencyContainer: DependencyContainable
    
    init(dependencyContainer: DependencyContainable) {
        self.dependencyContainer = dependencyContainer
        self.unauthorizedCoordinator = UnauthorizedCoordinator(dependencyContainer: dependencyContainer)
        setupListener()
    }
    
    private var currentUser: UserStorable {
        return dependencyContainer.getUserStore()
    }
    
    private func setupListener() {
        //withObservationTracking only gets callback on first change
        currentUser.getCurrentUserPublisher()
            .sink { [weak self] user in
                guard let self = self else { return }
                if let _ = user {
                    Task { @MainActor in
                        withAnimation {
                            self.authorizedCoordinator = AuthorizedCoordinator(dependencyContainer: self.dependencyContainer)
                        }
                    }
                }
                else {
                    Task { @MainActor in
                        withAnimation {
                            self.authorizedCoordinator = nil
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
