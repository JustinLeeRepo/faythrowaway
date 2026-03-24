//
//  AppointmentListViewModelTests.swift
//  Authorized
//
//  Created by Justin Lee on 3/23/26.
//

import XCTest
import Combine
@testable import Authorized
import Services
import DependencyContainer

final class AppointmentListViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = []
    }
    
    func test_fetchAppointments_success() async {
        let container = MockDependencyContainer()
        
        let vm = AppointmentListViewModel(
            dependencyContainer: container,
            appointmentTabEventPublisher: PassthroughSubject(),
            eventPublisher: PassthroughSubject()
        )
        
        await vm.fetchAppointments()
        
        XCTAssertGreaterThan(vm.appointments.count, 0)
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.error)
    }
    
    func test_fetchAppointments_failure() async {
        let mockService = MockAppointmentService()
        mockService.shouldThrow = true
        
        let container = MockDependencyContainer(appointmentService: mockService)
        
        let vm = AppointmentListViewModel(
            dependencyContainer: container,
            appointmentTabEventPublisher: PassthroughSubject(),
            eventPublisher: PassthroughSubject()
        )
        
        await vm.fetchAppointments()
        
        XCTAssertNotNil(vm.error)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_upcomingAppointments_filter() async {
        let container = MockDependencyContainer()
        let service = container.getAppointmentService()
        let appointments = try? await service.fetchAppointments()
        let upcomingAppointments = appointments?.filter({ $0.isUpcoming })
        
        let vm = AppointmentListViewModel(
            dependencyContainer: container,
            appointmentTabEventPublisher: PassthroughSubject(),
            eventPublisher: PassthroughSubject()
        )
        
        await vm.fetchAppointments()
        
        XCTAssertEqual(vm.currentAppointments.count, upcomingAppointments?.count)
    }
    
    func test_tabSwitching() {
        let subject = PassthroughSubject<AppointmentTabEvent, Never>()
        
        let vm = AppointmentListViewModel(
            dependencyContainer: MockDependencyContainer(),
            appointmentTabEventPublisher: subject,
            eventPublisher: PassthroughSubject()
        )
        
        let expectation = XCTestExpectation(description: "Tab updated")
        vm.$selectedTab
            .dropFirst()
            .sink { tab in
                if tab == .past {
                    expectation.fulfill()
                }
            }
        .store(in: &cancellables)
        
        subject.send(.selectedTab(.past))
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(vm.selectedTab, .past)
    }
    
    func test_pastAppointments_filter() async {
        let subject = PassthroughSubject<AppointmentTabEvent, Never>()
        let container = MockDependencyContainer()
        let service = container.getAppointmentService()
        let appointments = try? await service.fetchAppointments()
        let pastAppointments = appointments?.filter({ $0.isPast })
        
        let vm = AppointmentListViewModel(
            dependencyContainer: container,
            appointmentTabEventPublisher: subject,
            eventPublisher: PassthroughSubject()
        )
        await vm.fetchAppointments()
        
        let expectation = XCTestExpectation(description: "Tab updated")
        vm.$selectedTab
            .dropFirst()
            .sink { tab in
                if tab == .past {
                    expectation.fulfill()
                }
            }
        .store(in: &cancellables)
        
        subject.send(.selectedTab(.past))
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(vm.currentAppointments.count, pastAppointments?.count)
    }
}
