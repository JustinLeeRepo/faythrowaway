//
//  AppointmentCardView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine
import SwiftUI

struct AppointmentCardView: View {
    let viewModel: AppointmentCardViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    if let month = viewModel.monthAbbreviation,
                       let day = viewModel.dateDay {
                        
                        Text(month)
                            .font(.custom("Manrope-SemiBold", size: 12))
                            .kerning(1)
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.accent)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(viewModel.isNextUpcoming ? .accent.opacity(0.11) : .gray.opacity(0.09))
                        
                        Text("\(day)")
                            .font(.custom("Manrope-SemiBold", size: 18))
                            .lineSpacing(9)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.gray.opacity(0.05))
                    }
                }
                .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.timeTitle)
                        .font(.custom("Manrope-Bold", size: 14))
                        .lineSpacing(7)
                        .foregroundColor(.primary)
                    
                    Text(viewModel.typeTitle)
                        .font(.custom("Manrope-Medium", size: 12))
                        .lineSpacing(6)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            if viewModel.isNextUpcoming {
                
                Button {
                    viewModel.greatSuccess()
                } label: {
                    Label {
                        Text("Join appointment")
                            .font(.custom("Manrope-Bold", size: 14))
                            .lineSpacing(7)
                    } icon: {
                        Image(.videoCamera)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color(.label)
                        .opacity(0.1),
                    lineWidth: viewModel.isNextUpcoming ? 0.1 : 1
                )
                .shadow(
                    color:
                        Color(.label)
                        .opacity(viewModel.isNextUpcoming ? 1.0 : 0.0),
                    radius: 2.0,
                    x: 0,
                    y: 0
                )
        }
    }
}

#Preview {
    let appointment = Appointment(
        appointmentId: "mzdqmf1786",
        patientId: "1",
        providerId: "100",
        status: .scheduled,
        appointmentType: .followUp,
        start: "2025-01-27T17:45:00Z",
        end: "2025-01-27T18:30:00Z",
        durationInMinutes: 45,
        recurrenceType: .weekly
    )
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    
    let monthAbbreviator = DateFormatter()
    monthAbbreviator.dateFormat = "MMM"
    
    let eventPub = PassthroughSubject<GreatSuccessEvent, Never>()
    
    let viewModel = AppointmentCardViewModel(appointment: appointment, timeFormatter: timeFormatter, monthAbbreviator: monthAbbreviator, greatSuccessEventPub: eventPub)
    return AppointmentCardView(viewModel: viewModel)
}
