//
//  AppointmentsHeaderView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import Lottie
import SwiftUI

struct AppointmentsHeaderView: View {
    let viewModel: AppointmentsHeaderViewModel
    var body: some View {
        HStack {
            Text("Appointments")
                .font(.custom("Manrope-ExtraBold", size: 24))
                .padding()
            
            Spacer()
            
            Button {
                viewModel.createMeeting()
            } label: {
                Label {
                    Text("New")
                        .font(.custom("Manrope-Bold", size: 14))
                } icon: {
                    Image("Plus", bundle: .main)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(white: 229/255), lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
    }
}

#Preview {
    let eventPub = PassthroughSubject<AppointmentEvent, Never>()
    let viewModel = AppointmentsHeaderViewModel(appointmentEventPub: eventPub)
    return AppointmentsHeaderView(viewModel: viewModel)
}
