//
//  AppointmentsView.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Lottie
import SwiftUI

struct AppointmentsView: View {
    @ObservedObject var viewModel: AppointmentsViewModel
    
    var body: some View {
        VStack {
            AppointmentsHeaderView(viewModel: viewModel.appointmentsHeaderViewModel)
            AppointmentsTabView(viewModel: viewModel.appointmentsTabViewModel)
            AppointmentListView(viewModel: viewModel.appointmentListViewModel)
                .padding(.vertical)
        }
        .overlay {
            if viewModel.greatSuccess {
                lottieSuccess {
                    viewModel.greatSuccess = false
                }
            }
            
            if viewModel.veryNice {
                lottieSuccess {
                    viewModel.veryNice = false
                }
            }
        }
    }
    
    func lottieSuccess(completion: @escaping () -> Void = {} ) -> some View {
        LottieView(animation: .named("Sucess"))
            .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
            .animationDidFinish { completed in
                completion()
            }
            .padding()
            .background(.background)
            .clipShape(.rect(cornerRadius: 12.0))
    }
}

#Preview {
    let user = User(token: "")
    let viewModel = AppointmentsViewModel(user: user)
    return AppointmentsView(viewModel: viewModel)
}
