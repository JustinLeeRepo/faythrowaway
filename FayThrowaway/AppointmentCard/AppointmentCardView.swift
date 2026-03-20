//
//  AppointmentCardView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import Services
import SwiftUI

struct AppointmentCardView: View {
    let viewModel: AppointmentCardViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text(viewModel.monthAbbreviation)
                        .font(.custom("Manrope-SemiBold", size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.accent.opacity(0.1))
                        
                    Text("\(viewModel.dateDay)")
                        .font(.custom("Manrope-SemiBold", size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.gray.opacity(0.05))
                }
                .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.timeTitle)
                        .font(.custom("Manrope-Bold", size: 14))
                        .foregroundColor(.primary)
                    
                    Text(viewModel.typeTitle)
                        .font(.custom("Manrope-Medium", size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            if viewModel.isNextUpcoming {
                Button {
                    viewModel.joinMeeting()
                } label: {
                    Label {
                        Text("Join appointment")
                            .font(.custom("Manrope-Bold", size: 14))
                    } icon: {
                        Image(.videoCamera)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background {
            if viewModel.isNextUpcoming {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                    .shadow(
                        color:
                            Color(.label)
                            .opacity(0.1),
                        radius: 1.0,
                        x: 0,
                        y: 4
                    )
            }
        }
        .overlay {
            if !viewModel.isNextUpcoming {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color(.label)
                            .opacity(0.1),
                        lineWidth: 1
                    )
            }
        }
    }
}

#Preview {
    let appointment = MockAppointmentService().placeholderAppointments[0]
    
    let timeFormatter = DateFormatter()
    timeFormatter.timeZone = .current
    
    let eventPub = PassthroughSubject<AppointmentEvent, Never>()
    
    let viewModel = AppointmentCardViewModel(appointment: appointment, dateFormatter: timeFormatter, appointmentEventPub: eventPub)
    return AppointmentCardView(viewModel: viewModel)
}
