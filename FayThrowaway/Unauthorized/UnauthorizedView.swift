//
//  UnauthorizedView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/26/25.
//

import Combine
import Lottie
import SwiftUI

struct UnauthorizedView: View {
    @ObservedObject var viewModel: UnauthorizedViewModel
    @State var isLoading = false
    
    var body: some View {
        VStack {
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
        .overlay {
            VStack {
                ZStack {
                    Text("Yay Fay")
                        .fontDesign(.monospaced)
                        .font(.title)
                        .foregroundStyle(.accent)
                        .padding()
                        .glow()
                }
                
                Spacer()
            }
        }
        .background {
                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .glow()
        }
        .overlay {
            if let error = viewModel.error {
                VStack {
                    LottieView(animation: .named("Error"))
                        .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
                        .animationDidFinish { completed in
                            withAnimation {
                                viewModel.error = nil
                            }
                        }
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    Text(error.localizedDescription)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .font(.callout)
                }
                .background(.background)
                .clipShape(.rect(cornerRadius: 12.0))
            }
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
    let viewModel = UnauthorizedViewModel(unauthorizedEventPublisher: eventPublisher)
    return UnauthorizedView(viewModel: viewModel)
}
