//
//  AuthorizedCoordinatorView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import SwiftUI

struct AuthorizedCoordinatorView: View {
    typealias Tab = AuthorizedCoordinator.Tab
    @ObservedObject var coordinator: AuthorizedCoordinator
    @State var tab: AuthorizedCoordinator.Tab = .first
    var body: some View {
        TabView(selection: $tab) {
            AppointmentsView(viewModel: coordinator.appointmentsViewModel)
                .tabItem {
                    Label {
                        Text("Appointments")
                            .tabLabelStyle()
                    } icon: {
                        tab == .first ? Image(.calendarFill) : Image(.calendar)
                    }
                }
                .tag(Tab.first)
            
            Text("2")
                .tabItem {
                    Label {
                        Text("Chat")
                            .tabLabelStyle()
                    } icon: {
                        Image(.chats)
                    }
                }
                .tag(Tab.second)
            
            Text("3")
                .tabItem {
                    Label {
                        Text("Journal")
                            .tabLabelStyle()
                    } icon: {
                        Image(.notebook)
                    }
                }
                .tag(Tab.third)
            
            Text("4")
                .tabItem {
                    Label {
                        Text("Profile")
                            .tabLabelStyle()
                    } icon: {
                        Image(.user)
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
            .lineSpacing(2)
            .multilineTextAlignment(.center)
    }
}

extension View {
    func tabLabelStyle() -> some View {
        self.modifier(TabLabelStyle())
    }
}

#Preview {
    let user = User(token: "")
    let coordinator = AuthorizedCoordinator(user: user)
    return AuthorizedCoordinatorView(coordinator: coordinator)
}
