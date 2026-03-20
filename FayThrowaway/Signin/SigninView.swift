//
//  SigninView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SignInViewModel
    
    var body: some View {
        VStack {
            fields
                .padding(.horizontal)
            
            Button {
                Task {
                    await viewModel.proceed {
                        dismiss()
                    }
                }
            } label: {
                Text(viewModel.buttonTitle)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(.leading, 2)
                }
            }
            .inputStyling()
            
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .padding()
                    .font(.caption)
                    .foregroundStyle(.pink)
                    .opacity(viewModel.error == nil ? 0 : 1)
            }
        }
        .onDisappear {
            viewModel.clearUsername()
        }
    }
    
    
    
    @ViewBuilder
    private var fields: some View {
        TextField("Username", text: $viewModel.usernameText)
            .inputStyling()
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.clearUsername()
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                    .padding(.trailing)
                }
                .opacity(viewModel.isUsernameEmpty ? 0 : 1)
            }
        
        SecureField("Password", text: $viewModel.passwordText)
            .inputStyling()
            .overlay(alignment: .trailing) {
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.clearPassword()
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                    .padding(.trailing)
                }
                .opacity(viewModel.isPasswordEmpty ? 0 : 1)
            }
    }
}

//TODO: move to extensions

struct InputStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.regularMaterial)
            .clipShape(.capsule)
    }
}

extension View {
    func inputStyling() -> some View {
        modifier(InputStyling())
    }
}

#Preview {
    let viewModel = SignInViewModel(dependencyContainer: MockDependencyContainer())
    SignInView(viewModel: viewModel)
}
