//
//  AppointmentListView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import Lottie
import SwiftUI

struct AppointmentListView: View {
    @ObservedObject var viewModel: AppointmentListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.currentAppointments.enumerated()), id: \.element.id) { (index, appointment) in
                    let appointmentCardViewModel = viewModel.appointmentCardViewModel(appointment: appointment, isFirst: index == 0)
                    AppointmentCardView(viewModel: appointmentCardViewModel)
                }
            }
            .padding(.horizontal)
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
    let appointments: [Appointment] = [
        Appointment(
            appointmentId: "mzdqmf1786",
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: "2025-01-27T17:45:00Z",
            end: "2025-01-27T18:30:00Z",
            durationInMinutes: 45,
            recurrenceType: .weekly
        ),
        Appointment(
            appointmentId: "dcb02amiu9",
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: "2025-06-20T11:00:00Z",
            end: "2025-06-20T12:00:00Z",
            durationInMinutes: 60,
            recurrenceType: .weekly
        ),
        Appointment(
            appointmentId: "cjy7yp7nm5",
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: "2025-08-10T10:45:00Z",
            end: "2025-08-10T11:30:00Z",
            durationInMinutes: 45,
            recurrenceType: .weekly
        ),
        Appointment(
            appointmentId: "n30kl8mpvo",
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: "2025-08-15T11:45:00Z",
            end: "2025-08-15T12:30:00Z",
            durationInMinutes: 45,
            recurrenceType: .weekly
        ),
        Appointment(
            appointmentId: "509teq10vh",
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: "2025-10-10T17:45:00Z",
            end: "2025-10-10T18:30:00Z",
            durationInMinutes: 45,
            recurrenceType: .weekly
        ),
        Appointment(
            appointmentId: "fkvedohjev",
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: "2025-12-11T20:00:00Z",
            end: "2025-12-11T21:00:00Z",
            durationInMinutes: 60,
            recurrenceType: .weekly
        ),
        Appointment(
            appointmentId: "v7y0i184hf",
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: "2025-12-15T17:00:00Z",
            end: "2025-12-15T18:00:00Z",
            durationInMinutes: 60,
            recurrenceType: .weekly
        ),
        Appointment(
            appointmentId: "uarlir2drj",
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: "2025-12-19T20:00:00Z",
            end: "2025-12-19T21:00:00Z",
            durationInMinutes: 60,
            recurrenceType: .weekly
        ),
        Appointment(
            appointmentId: "a9xdflac00",
            patientId: "1",
            providerId: "100",
            status: .occurred,
            appointmentType: .followUp,
            start: "2024-09-10T17:45:00Z",
            end: "2024-09-10T18:30:00Z",
            durationInMinutes: 45,
            recurrenceType: .monthly
        ),
        Appointment(
            appointmentId: "x1r16i380u",
            patientId: "1",
            providerId: "100",
            status: .occurred,
            appointmentType: .initialConsultation,
            start: "2024-05-28T20:00:00Z",
            end: "2024-05-28T21:00:00Z",
            durationInMinutes: 60,
            recurrenceType: .weekly
        )
    ]
    
    let appointmentTabEventPublisher = PassthroughSubject<AppointmentTabEvent, Never>()
    let eventPublisher = PassthroughSubject<GreatSuccessEvent, Never>()
    
    let viewModel = AppointmentListViewModel(appointmentTabEventPublisher: appointmentTabEventPublisher, eventPublisher: eventPublisher)
    viewModel.appointments = appointments
    
    return AppointmentListView(viewModel: viewModel)
}
