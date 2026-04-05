//
//  SigninView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import DependencyContainer
import SwiftUI

enum Field: Hashable {
    case username
    case password
}

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SignInViewModel
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            fields
                .padding(.horizontal)
            
            Button {
                Task {
                    await viewModel.proceed {
                        focusedField = nil
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
        .onAppear {
            focusedField = .username
        }
        .onDisappear {
            viewModel.clearUsername()
        }
    }
    
    
    
    @ViewBuilder
    private var fields: some View {
        TextField("Username", text: $viewModel.usernameText)
            .inputStyling()
            .focused($focusedField, equals: .username)
            .onSubmit {
                focusedField = .password
            }
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
            .focused($focusedField, equals: .password)
            .onSubmit {
                Task {
                    await viewModel.proceed {
                        focusedField = nil
                        dismiss()
                    }
                }
            }
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
