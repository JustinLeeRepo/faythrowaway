//
//  RootCoordinator.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import SwiftUI

class RootCoordinator: ObservableObject {
    //TODO: check if token / session is persisted 
    @Published var isAuthorized = false
    @Published var authorizedCoordinator: AuthorizedCoordinator?
    
    private var authService = AuthService.shared
    private var currentUser = CurrentUser.shared
    private var cancellables = Set<AnyCancellable>()
    
    let unauthorizedCoordinator: UnauthorizedCoordinator
    
    init(isAuthorized: Bool = false) {
        self.isAuthorized = isAuthorized
        self.unauthorizedCoordinator = UnauthorizedCoordinator()
        
        setupListener()
    }
    
    private func setupListener() {
        currentUser.$user
            .sink { [weak self] user in
                guard let self = self else { return }
                self.isAuthorized = user != nil
                
                if let user = user {
                    Task { @MainActor in
                        self.authorizedCoordinator = AuthorizedCoordinator()
                    }
                }
                else {
                    Task { @MainActor in
                        self.authorizedCoordinator = nil
                    }
                }
            }
            .store(in: &cancellables)
    }
}
