//
//  AppointmentListView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import SwiftUI

struct AppointmentListView: View {
    let appointments: [Appointment]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(appointments) { appointment in
                    AppointmentCardView(appointment: appointment)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct AppointmentCardView: View {
    let appointment: Appointment
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    if let startDate = appointment.startDate {
                        
                        Text(DateFormatter.monthAbbreviation.string(from: startDate).uppercased())
                            .font(.custom("Manrope-SemiBold", size: 12))
                            .kerning(1)
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                            .textCase(.uppercase)
                            .foregroundColor(.accent)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(appointment.isUpcoming ? .accent.opacity(0.11) : .gray.opacity(0.09))
                        
                        Text("\(Calendar.current.component(.day, from: startDate))")
                            .font(.custom("Manrope-SemiBold", size: 18))
                            .lineSpacing(9)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(appointment.isUpcoming ? .gray.opacity(0.05) : .gray.opacity(0.05))
                    }
                }
                .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    if let startDate = appointment.startDate,
                       let endDate = appointment.endDate {
                        Text("\(timeFormatter.string(from: startDate)) - \(timeFormatter.string(from: endDate)) (PT)")
                            .font(.custom("Manrope-Bold", size: 14))
                            .lineSpacing(7)
                            .foregroundColor(.primary)
                    }
                    Text(appointment.appointmentType.rawValue)
                        .font(.custom("Manrope-Medium", size: 12))
                        .lineSpacing(6)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            if appointment.isFirstUpcoming {
                
                Button {
                    // TDOO:
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
                .stroke(Color(.label).opacity(0.1), lineWidth: appointment.isFirstUpcoming ? 0.1 : 1)
                .shadow(color: Color(.label).opacity(appointment.isFirstUpcoming ? 1.0 : 0.0), radius: 2.0, x: 0, y: 0)
        }
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
    }
}

// Helper extension for month abbreviation
extension DateFormatter {
    static let monthAbbreviation: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
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
    
    return AppointmentListView(appointments: appointments)
}
