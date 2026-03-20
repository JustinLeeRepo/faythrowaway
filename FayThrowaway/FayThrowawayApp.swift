//
//  FayThrowawayApp.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import DependencyContainer
import SwiftUI

@main
struct FayThrowawayApp: App {
    @State var coordinator: RootCoordinator = .init(dependencyContainer: DependencyContainer.shared)
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(coordinator: coordinator)
        }
    }
}
