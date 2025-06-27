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
            Text("YO")
                .tabItem {
                    Label("Appointments", image: tab == .first ? .calendarFill : .calendar)
                }
                .tag(Tab.first)
            
            Text("2")
                .tabItem {
                    Label("Chat", image: .chats)
                }
                .tag(Tab.second)
            
            Text("3")
                .tabItem {
                    Label("Journal", image: .notebook)
                }
                .tag(Tab.third)
            
            Text("4")
                .tabItem {
                    Label("Profile", image: .user)
                }
                .tag(Tab.fourth)
            
        }
    }
}

#Preview {
    let user = User(token: "")
    let coordinator = AuthorizedCoordinator(user: user)
    return AuthorizedCoordinatorView(coordinator: coordinator)
}
