//
//  AuthorizedCoordinatorView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import DependencyContainer
import SwiftUI

public struct AuthorizedCoordinatorView: View {
    typealias Tab = AuthorizedCoordinator.Tab
    @ObservedObject var coordinator: AuthorizedCoordinator
    
    public init(coordinator: AuthorizedCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        TabView(selection: $coordinator.tab) {
            AppointmentsView(viewModel: coordinator.appointmentsViewModel)
                .tabItem {
                    Label {
                        Text("Appointments")
                            .tabLabelStyle()
                    } icon: {
                        coordinator.tab == .first ? Image("Calendar.Fill", bundle: .main) : Image("Calendar", bundle: .main)
                    }
                }
                .tag(Tab.first)
            
            Text("2")
                .tabItem {
                    Label {
                        Text("Chat")
                            .tabLabelStyle()
                    } icon: {
                        Image("Chats", bundle: .main)
                    }
                }
                .tag(Tab.second)
            
            Text("3")
                .tabItem {
                    Label {
                        Text("Journal")
                            .tabLabelStyle()
                    } icon: {
                        Image("Notebook", bundle: .main)
                    }
                }
                .tag(Tab.third)
            
            Text("4")
                .tabItem {
                    Label {
                        Text("Profile")
                            .tabLabelStyle()
                    } icon: {
                        Image("User", bundle: .main)
                    }
                }
                .tag(Tab.fourth)
            
        }
    }
}

struct TabLabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Manrope-SemiBold", size: 10))
            .multilineTextAlignment(.center)
    }
}

extension View {
    func tabLabelStyle() -> some View {
        self.modifier(TabLabelStyle())
    }
}

#Preview {
    let coordinator = AuthorizedCoordinator(dependencyContainer: MockDependencyContainer())
    AuthorizedCoordinatorView(coordinator: coordinator)
}
