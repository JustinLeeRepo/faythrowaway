//
//  FayThrowawayApp.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import SwiftUI

@main
struct FayThrowawayApp: App {
    @StateObject var coordinator: RootCoordinator = .init()
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(coordinator: coordinator)
        }
    }
}
