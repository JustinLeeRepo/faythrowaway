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
    private let authService = AuthService.shared
    
    init(model: SignInModel) {
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
    
    func proceed(completion: @escaping () -> Void = {}) async {
        do {
            try await authService.signIn(username: usernameText, password: passwordText)
            
            Task { @MainActor in
                self.error = nil
                //dismiss (completion) only on success
                completion()
            }
        }
        catch {
            Task { @MainActor in
                self.error = error
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
    
    private func setError(_ error: Error) {
        self.error = error
    }
}
