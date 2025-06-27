//
//  UnauthorizedViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import SwiftUI

class UnauthorizedViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    
    private let unauthorizedEventPublisher: PassthroughSubject<UnauthorizedEvent, Never>
    private let authService: AuthService = AuthService.shared
    
    init(unauthorizedEventPublisher: PassthroughSubject<UnauthorizedEvent, Never>) {
        self.unauthorizedEventPublisher = unauthorizedEventPublisher
    }
    
    func proceedToSignIn() {
        unauthorizedEventPublisher.send(.proceedToSignIn)
    }
    
    func expressSignIn() async {
        Task { @MainActor in
            withAnimation {
                isLoading = true
            }
        }
        
        do {
            try await authService.expressSignIn()
            
            Task {@MainActor in
                withAnimation {
                    self.isLoading = false
                }
            }
        }
        catch {
            Task { @MainActor in
                self.error = error
            }
        }
    }
}
