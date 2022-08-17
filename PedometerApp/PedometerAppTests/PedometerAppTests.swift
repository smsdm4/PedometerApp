//
//  PedometerAppTests.swift
//  PedometerAppTests
//
//  Created by Mojtaba Mirzadeh on 8/8/22.
//

import XCTest
import CoreMotion
@testable import PedometerApp
 
class PedometerAppTests: XCTestCase {
    
    // MARK: - Right way --> Indipendent test.
    func test_StartsPedometer(){
        
        let mockPedometer = MockPedometer()
        let pedometerVM = PedometerViewModel(pedometer: mockPedometer)
        pedometerVM.startPedometer()
        
        XCTAssertTrue(mockPedometer.started)
        
    }
    
    func test_PedometerAuthorized_ShouldBeInProgress(){
        
        let mockPedometer = MockPedometer()
        mockPedometer.permisionDeclined = false
        let pedometerVM = PedometerViewModel(pedometer: mockPedometer)
        
        pedometerVM.startPedometer()
        
        XCTAssertEqual(pedometerVM.appState, .inProgress)
    }
    
    func test_PedometerNotAuthorized_DoesNotStart(){
        
        let mockPedometer = MockPedometer()
        mockPedometer.permisionDeclined = true
        let pedometerVM = PedometerViewModel(pedometer: mockPedometer)
        
        pedometerVM.startPedometer()
        
        XCTAssertEqual(pedometerVM.appState, .notStarted)
    }
    
    func test_PedometerNotAvailable_DoesNotStart(){
        
        let mockPedometer = MockPedometer()
        mockPedometer.pedometerAvailable = false
        
        let pedometerVM = PedometerViewModel(pedometer: mockPedometer)
         
        XCTAssertEqual(pedometerVM.appState, .notStarted)
        
    }
    
    func test_WhenAuthDeniedAfterStartGenerateError(){
         
        let mockPedometer = MockPedometer()
        mockPedometer.error = MockPedometer.notAuthorizedError
        
        let pedometerVM = PedometerViewModel(pedometer: mockPedometer)
        
        let exp = expectation(for: NSPredicate(block: { (thing, _)-> Bool in
            
            let vm = thing as! PedometerViewModel
            return vm.appState == .notAuthorized
            
        }), evaluatedWith: pedometerVM, handler: nil)
        
        pedometerVM.startPedometer()
        
        wait(for: [exp], timeout: 2.0)
        
    }
    
    func test_WhenPedometerUpdatesThenUpdatesViewModel() {
        
        let data = MockData(steps: 100, travelledDistance: 10)
        
        let mockPedometer = MockPedometer()
        let pedometerVM = PedometerViewModel(pedometer: mockPedometer)
        
        pedometerVM.startPedometer()
        
        mockPedometer.sendData(data)
        
        XCTAssertEqual(100, pedometerVM.steps)
        XCTAssertEqual(10, pedometerVM.travelledDistance)
        
    }

    // MARK: - Wrong way --> because we dont have any real data(A good test should noe depend any thing else), So we need to use fake data to run our test.
    func /*test_*/CMPedometer_LoadingHistoricalData() {
        
        var data: CMPedometerData?
        let now = Date()
        let then = now.addingTimeInterval(-1000)
        let exp = expectation(description: "Pedometer query returns...")
        
        let pedometer = CMPedometer()
        pedometer.queryPedometerData(from: now, to: then) { pedometerData, error in
            
            data = pedometerData
            exp.fulfill()
            
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(data)
        
        if let steps = data?.numberOfSteps {
            XCTAssert(steps.intValue > 0)
        }
        
    }

}
