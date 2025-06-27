//
//  UnauthorizedCoordinatorView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import SwiftUI

struct UnauthorizedCoordinatorView: View {
    @ObservedObject var coordinator = UnauthorizedCoordinator()
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            UnauthorizedView(viewModel: coordinator.unauthorizedViewModel)
                .navigationDestination(for: SignInModel.self) { model in
                    let viewModel = coordinator.createSignInViewModel(model: model)
                    SignInView(viewModel: viewModel)
                }
        }
    }
}

#Preview {
    UnauthorizedCoordinatorView()
}
