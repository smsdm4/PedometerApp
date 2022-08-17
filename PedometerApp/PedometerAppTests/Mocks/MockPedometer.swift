//
//  MockPedometer.swift
//  PedometerAppTests
//
//  Created by Mojtaba Mirzadeh on 8/13/22.
//

import Foundation
import CoreMotion
@testable import PedometerApp

class MockPedometer: Pedometer {
    
    var error: Error?
    var pedometerAvailable: Bool = true
    var permisionDeclined: Bool = false
    private (set) var started: Bool = false
    
    var updateBlock: ((Error?) -> Void)?
    var dataBlock: ((PedometerData?, Error?) -> Void)?
    
    static let notAuthorizedError = NSError(domain: CMErrorDomain, code: Int(CMErrorMotionActivityNotAuthorized.rawValue), userInfo: nil)
    
    func sendData(_ data: PedometerData) {
        self.dataBlock?(data, self.error)
    }
    
    func start(dataUpdates: @escaping (PedometerData?, Error?) -> Void, eventUpdates: @escaping (Error?) -> Void) {
        
        self.started = true
        self.updateBlock = eventUpdates
        self.dataBlock = dataUpdates
        
        DispatchQueue.global(qos: .default).async {
            self.updateBlock?(self.error)
        }
        
    }
    
}
