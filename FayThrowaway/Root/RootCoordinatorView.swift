//
//  RootCoordinatorView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import SwiftUI

struct RootCoordinatorView: View {
    @ObservedObject var coordinator: RootCoordinator
    
    var body: some View {
        ZStack {
            if let authorizedCoordinator = coordinator.authorizedCoordinator {
                AuthorizedCoordinatorView(coordinator: authorizedCoordinator)
                    .opacity(coordinator.isAuthorized ? 1 : 0)
            }
            else {
                UnauthorizedCoordinatorView(coordinator: coordinator.unauthorizedCoordinator)
                    .opacity(coordinator.isAuthorized ? 0 : 1)
            }
        }
    }
}

#Preview {
    let coordinator = RootCoordinator()
    return RootCoordinatorView(coordinator: coordinator)
}
