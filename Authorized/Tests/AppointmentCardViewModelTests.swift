//
//  Test.swift
//  Authorized
//
//  Created by Justin Lee on 3/23/26.
//

import XCTest
import Combine
@testable import Authorized
import Services

final class AppointmentCardViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = []
    }
    
    func test_monthAbbreviation() {
        let appointment = Appointment.mockUpcoming
        let formatter = DateFormatter()
        let subject = PassthroughSubject<AppointmentEvent, Never>()
        
        let vm = AppointmentCardViewModel(
            appointment: appointment,
            dateFormatter: formatter,
            appointmentEventPub: subject
        )
        
        XCTAssertFalse(vm.monthAbbreviation.isEmpty)
    }
    
    func test_dateDay() {
        let appointment = Appointment.mockUpcoming
        let formatter = DateFormatter()
        let subject = PassthroughSubject<AppointmentEvent, Never>()
        
        let vm = AppointmentCardViewModel(
            appointment: appointment,
            dateFormatter: formatter,
            appointmentEventPub: subject
        )
        
        XCTAssertGreaterThan(vm.dateDay, 0)
        XCTAssertLessThan(vm.dateDay, 32)
    }
    
    func test_timeTitle_nextUpcoming() {
        let appointment = Appointment.mockUpcoming
        let formatter = DateFormatter()
        let subject = PassthroughSubject<AppointmentEvent, Never>()
        
        let vm = AppointmentCardViewModel(
            appointment: appointment,
            dateFormatter: formatter,
            isNextUpcoming: true,
            appointmentEventPub: subject
        )
        
        XCTAssertTrue(vm.timeTitle.contains("-"))
        XCTAssertTrue(vm.timeTitle.contains("("))
        XCTAssertTrue(vm.timeTitle.contains(")"))
    }
    
    func test_timeTitle() {
        let appointment = Appointment.mockUpcoming
        let formatter = DateFormatter()
        let subject = PassthroughSubject<AppointmentEvent, Never>()
        
        let vm = AppointmentCardViewModel(
            appointment: appointment,
            dateFormatter: formatter,
            appointmentEventPub: subject
        )
        
        XCTAssertFalse(vm.timeTitle.contains("-"))
        XCTAssertFalse(vm.timeTitle.contains("("))
        XCTAssertFalse(vm.timeTitle.contains(")"))
    }
    
    func test_typeTitle() {
        let appointment = Appointment.mockUpcoming
        let formatter = DateFormatter()
        let subject = PassthroughSubject<AppointmentEvent, Never>()
        
        let vm = AppointmentCardViewModel(
            appointment: appointment,
            dateFormatter: formatter,
            appointmentEventPub: subject
        )
        
        XCTAssertEqual(appointment.appointmentType.rawValue, vm.typeTitle)
        XCTAssertFalse(vm.typeTitle.contains(appointment.providerName))
        XCTAssertFalse(vm.typeTitle.contains(appointment.providerType))
    }
    
    func test_typeTitle_nextUpcomming() {
        let appointment = Appointment.mockUpcoming
        let formatter = DateFormatter()
        let subject = PassthroughSubject<AppointmentEvent, Never>()
        
        let vm = AppointmentCardViewModel(
            appointment: appointment,
            dateFormatter: formatter,
            isNextUpcoming: true,
            appointmentEventPub: subject
        )
        
        XCTAssertTrue(vm.typeTitle.contains(appointment.providerName))
        XCTAssertTrue(vm.typeTitle.contains(appointment.providerType))
    }
    
    func test_joinMeeting_emitsEvent() {
        let expectation = XCTestExpectation(description: "Event emitted")
        let subject = PassthroughSubject<AppointmentEvent, Never>()
        
        let vm = AppointmentCardViewModel(
            appointment: .mockUpcoming,
            dateFormatter: DateFormatter(),
            appointmentEventPub: subject
        )
        
        subject.sink { event in
            if case .joinMeeting = event {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        vm.joinMeeting()
        
        wait(for: [expectation], timeout: 1)
    }
}
