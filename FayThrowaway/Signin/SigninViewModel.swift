//
//  SigninViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import SwiftUI

struct SignInModel: Hashable {
    var usernameText: String = ""
    var passwordText: String = ""
    
    var isUsernameEmpty: Bool = true
    var isPasswordEmpty: Bool = true
    
    var buttonTitle: String {
        "Sign In"
    }
}

class SignInViewModel: ObservableObject {
    
    @Published var model: SignInModel
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    private let authService: AuthServicable
    
    init(dependencyContainer: DependencyContainable, model: SignInModel = SignInModel()) {
        self.authService = dependencyContainer.getAuthService()
        self.model = model
    }
    
    var isUsernameEmpty: Bool {
        model.isUsernameEmpty
    }
    
    var isPasswordEmpty: Bool {
        model.isPasswordEmpty
    }
    
    var usernameText: String {
        get {
            model.usernameText
        }
        set {
            model.usernameText = newValue
            withAnimation {
                model.isUsernameEmpty = newValue.isEmpty
            }
        }
    }
    
    var passwordText: String {
        get {
            model.passwordText
        }
        set {
            model.passwordText = newValue
            withAnimation {
                model.isPasswordEmpty = newValue.isEmpty
            }
        }
    }
    
    var buttonTitle: String {
        model.buttonTitle
    }
    
    @MainActor
    func proceed(completion: @escaping () -> Void = {}) async {
        withAnimation {
            isLoading = true
        }
        
        do {
            try await authService.signIn(username: usernameText, password: passwordText)
            
            withAnimation {
                self.error = nil
                self.isLoading = false
                //dismiss (completion) only on success
                completion()
                self.model = SignInModel()
            }
        }
        catch {
            withAnimation {
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    func clearUsername() {
        withAnimation {
            usernameText = ""
        }
    }
    
    func clearPassword() {
        withAnimation {
            passwordText = ""
        }
    }
}

extension SignInViewModel: Hashable {
    static func == (lhs: SignInViewModel, rhs: SignInViewModel) -> Bool {
        lhs.model == rhs.model
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }
}

