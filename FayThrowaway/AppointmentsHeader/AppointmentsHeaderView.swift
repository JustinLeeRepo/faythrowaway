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
    @ObservedObject var viewModel: AppointmentsHeaderViewModel
    var body: some View {
        HStack {
            Text("Appointments")
                .font(.custom("Manrope-ExtraBold", size: 24))
                .lineSpacing(12)
                .padding()
            
            Spacer()
            
            Button {
                viewModel.veryNice()
            } label: {
                Label {
                    Text("New")
                        .font(.custom("Manrope-Bold", size: 14))
                        .lineSpacing(7)
                } icon: {
                    Image(.plus)
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
    let eventPub = PassthroughSubject<GreatSuccessEvent, Never>()
    let viewModel = AppointmentsHeaderViewModel(greatSuccessEventPub: eventPub)
    return AppointmentsHeaderView(viewModel: viewModel)
}
