//
//  AppointmentsTabView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import SwiftUI

struct AppointmentsTabView: View {
    @ObservedObject var viewModel: AppointmentsViewModel
    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "Upcoming", isSelected: viewModel.selectedTab == 0) {
                viewModel.selectedTab = 0
            }
            
            TabButton(title: "Past", isSelected: viewModel.selectedTab == 1) {
                viewModel.selectedTab = 1
            }
        }
        .padding(.top)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.custom("Manrope-Bold", size: 14))
                    .lineSpacing(7)
                    .foregroundColor(isSelected ? .accent : .gray)
                
                Rectangle()
                    .fill(isSelected ? .accent : .gray)
                    .frame(height: isSelected ? 2 : 1)
            }
        }
    }
}

#Preview {
    let user = User(token: "")
    let viewModel = AppointmentsViewModel(user: user)
    return AppointmentsTabView(viewModel: viewModel)
}
