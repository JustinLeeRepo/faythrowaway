//
//  UnauthorizedView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import DependencyContainer
import Lottie
import SwiftUI

struct UnauthorizedView: View {
    @ObservedObject var viewModel: UnauthorizedViewModel
    @State var isLoading = false
    
    var body: some View {
        VStack {
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .padding()
                    .font(.caption)
                    .foregroundStyle(.pink)
                    .opacity(viewModel.error == nil ? 0 : 1)
            }
            
            Spacer()
            
            Button {
                viewModel.proceedToSignIn()
            } label: {
                Label("Sign in", systemImage: "at")
                
            }
            .inputStyling()
            
            Button {
                Task {
                    await viewModel.expressSignIn()
                }
            } label: {
                Label("Express", systemImage: "person.slash")
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(.leading, 2)
                }
            }
            .inputStyling()
            
            Text("By continuing, you agree to our [User Agreement](https://www.apple.com/legal/internet-services/itunes/dev/stdeula/) and acknoledge that you understand the [Privacy Policy](http://apps.apple.com/us/app/mila-maps/id6747472776)")
                .padding()
                .font(.caption)
                .multilineTextAlignment(.leading)
        }
        .background {
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .glow()
        }
    }
}

struct Glow: ViewModifier {
    @State private var throb = false
    func body(content: Content) -> some View {
        let animation = Animation
            .linear(duration: 0.5)
            .repeatForever(autoreverses: true)
        
        ZStack {
            content
                .blur(radius: throb ? 25 : 5)
                // hack for animations embedded in navStack
                // https://developer.apple.com/forums/thread/682779
                .task {
                    withAnimation(animation) {
                        throb = true
                    }
                }
            
            content
        }
    }
}

extension View {
    func glow() -> some View {
        modifier(Glow())
    }
}

#Preview {
    let eventPublisher = PassthroughSubject<UnauthorizedEvent, Never>()
    let viewModel = UnauthorizedViewModel(dependencyContainer: MockDependencyContainer(), unauthorizedEventPublisher: eventPublisher)
    UnauthorizedView(viewModel: viewModel)
}
