//
//  AppointmentListView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import DependencyContainer
import Lottie
import SwiftUI

struct AppointmentListView: View {
    @ObservedObject var viewModel: AppointmentListViewModel
    
    var body: some View {
        ScrollView {
            switch viewModel.state {
            case .empty:
                ContentUnavailableView("No Appointments", systemImage: "slash.circle")
            case .ready:
                LazyVStack(spacing: 12) {
                    ForEach(Array(viewModel.currentAppointments.enumerated()), id: \.element.id) { (index, appointment) in
                        let appointmentCardViewModel = viewModel.appointmentCardViewModel(appointment: appointment, isFirst: index == 0)
                        AppointmentCardView(viewModel: appointmentCardViewModel)
                    }
                }
                .padding(.horizontal)
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
            }
        }
        .refreshable {
            Task {
                await viewModel.fetchAppointments()
            }
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

#Preview {
    
    let appointmentTabEventPublisher = PassthroughSubject<AppointmentTabEvent, Never>()
    let eventPublisher = PassthroughSubject<AppointmentEvent, Never>()
    
    let viewModel = AppointmentListViewModel(
        dependencyContainer: MockDependencyContainer(),
        appointmentTabEventPublisher: appointmentTabEventPublisher,
        eventPublisher: eventPublisher)
    
    return AppointmentListView(viewModel: viewModel)
}
