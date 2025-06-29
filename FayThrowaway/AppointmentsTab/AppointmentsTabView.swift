//
//  AppointmentsTabView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import SwiftUI

struct AppointmentsTabView: View {
    @ObservedObject var viewModel: AppointmentsTabViewModel
    var body: some View {
        HStack(spacing: 0) {
            tabButton(tab: .upcoming)
            
            tabButton(tab: .past)
        }
        .padding(.top)
    }
    
    func tabButton(tab: AppointmentTab) -> some View {
        Button {
            Task { @MainActor in
                viewModel.selectedTab = tab
                viewModel.switchTab()
            }
        } label: {
            VStack(spacing: 4) {
                Text(tab.rawValue)
                    .font(.custom("Manrope-Bold", size: 14))
                    .lineSpacing(7)
                    .foregroundColor(viewModel.selectedTab == tab ? .accent : .gray)
                
                Rectangle()
                    .fill(viewModel.selectedTab == tab ? .accent : .gray)
                    .frame(height: viewModel.selectedTab == tab ? 2 : 1)
            }
        }
    }
}

#Preview {
    let eventPublisher = PassthroughSubject<AppointmentTabEvent, Never>()
    let viewModel = AppointmentsTabViewModel(eventPublisher: eventPublisher)
    return AppointmentsTabView(viewModel: viewModel)
}
