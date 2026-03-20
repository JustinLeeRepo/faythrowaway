//
//  UnauthorizedCoordinatorView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import DependencyContainer
import SwiftUI

public struct UnauthorizedCoordinatorView: View {
    @ObservedObject var coordinator: UnauthorizedCoordinator
    
    public init(coordinator: UnauthorizedCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            UnauthorizedView(viewModel: coordinator.unauthorizedViewModel)
                .navigationDestination(for: SignInViewModel.self) { viewModel in
                    SignInView(viewModel: viewModel)
                }
        }
    }
}

#Preview {
    let coordinator = UnauthorizedCoordinator(dependencyContainer: MockDependencyContainer())
    UnauthorizedCoordinatorView(coordinator: coordinator)
}
