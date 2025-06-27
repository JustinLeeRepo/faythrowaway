//
//  AppointmentsView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import SwiftUI

struct AppointmentsView: View {
    @ObservedObject var viewModel: AppointmentsViewModel
    
    var body: some View {
        VStack {
            AppointmentsHeaderView()
            AppointmentsTabView(viewModel: viewModel.appointmentsTabViewModel)
            AppointmentListView(viewModel: viewModel.appointmentListViewModel)
                .padding(.vertical)
        }
    }
}

#Preview {
    let user = User(token: "")
    let viewModel = AppointmentsViewModel(user: user)
    return AppointmentsView(viewModel: viewModel)
}
