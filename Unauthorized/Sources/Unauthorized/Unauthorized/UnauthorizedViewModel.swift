//
//  UnauthorizedViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import DependencyContainer
import Services
import SwiftUI

class UnauthorizedViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    
    private let unauthorizedEventSubject: PassthroughSubject<UnauthorizedEvent, Never>
    private let authService: AuthServicable
    
    init(
        dependencyContainer: DependencyContainable,
        unauthorizedEventSubject: PassthroughSubject<UnauthorizedEvent, Never>
    ) {
        self.authService = dependencyContainer.getAuthService()
        self.unauthorizedEventSubject = unauthorizedEventSubject
    }
    
    func proceedToSignIn() {
        unauthorizedEventSubject.send(.proceedToSignIn)
    }
    
    @MainActor
    func expressSignIn() async {
        withAnimation {
            isLoading = true
        }
        
        do {
            try await authService.expressSignIn()
            
            withAnimation {
                self.isLoading = false
                self.error = nil
            }
        }
        catch {
            withAnimation {
                self.error = error
                self.isLoading = false
                
                Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    
                    withAnimation {
                        self.error = nil
                    }
                }
            }
        }
    }
}
