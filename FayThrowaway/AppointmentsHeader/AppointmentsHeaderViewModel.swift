//
//  AppointmentsHeaderViewModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 6/27/25.
//

import Combine

class AppointmentsHeaderViewModel: ObservableObject {
    private let greatSuccessEventPub: PassthroughSubject<GreatSuccessEvent, Never>
    
    init(greatSuccessEventPub: PassthroughSubject<GreatSuccessEvent, Never>) {
        self.greatSuccessEventPub = greatSuccessEventPub
    }
    
    func veryNice() {
        greatSuccessEventPub.send(.veryNice)
    }
}
