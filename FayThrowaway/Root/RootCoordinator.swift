//
//  RootCoordinator.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import SwiftUI

@MainActor
class RootCoordinator: ObservableObject {
    //TODO: check if token / session is persisted 
    @Published var isAuthorized = false
    @Published var user: User?
    
    private var authService = AuthService.shared
    private var currentUser = CurrentUser.shared
    private var cancellables = Set<AnyCancellable>()
    
    let unauthorizedCoordinator: UnauthorizedCoordinator
    var authorizedCoordinator: AuthorizedCoordinator?
    
    init(isAuthorized: Bool = false) {
        self.isAuthorized = isAuthorized
        self.unauthorizedCoordinator = UnauthorizedCoordinator()
        
        setupListener()
    }
    
    private func setupListener() {
        currentUser.$user
            .sink { [weak self] user in
                self?.user = user
                self?.isAuthorized = user != nil
                
                if let user = user {
                    self?.authorizedCoordinator = AuthorizedCoordinator(user: user)
                }
                else {
                    self?.authorizedCoordinator = nil
                }
            }
            .store(in: &cancellables)
    }
}
