//
//  RootCoordinatorView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import DependencyContainer
import SwiftUI

struct RootCoordinatorView: View {
    var coordinator: RootCoordinator
    
    var body: some View {
        switch coordinator.state {
        case .authorized(let authorizedCoordinator):
            AuthorizedCoordinatorView(coordinator: authorizedCoordinator)
            
        case .unauthorized(let unauthorizedCoordinator):
            UnauthorizedCoordinatorView(coordinator: unauthorizedCoordinator)
        }
    }
}

#Preview {
    let coordinator = RootCoordinator(dependencyContainer: MockDependencyContainer())
    RootCoordinatorView(coordinator: coordinator)
}
