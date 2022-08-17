//
//  CMPedometerExtension.swift
//  PedometerApp
//
//  Created by Mojtaba Mirzadeh on 8/13/22.
//

import Foundation
import CoreMotion

extension CMPedometer: Pedometer {
    
    var pedometerAvailable: Bool {
        return CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.authorizationStatus() != .restricted
    }
    
    var permisionDeclined: Bool {
        return CMPedometer.authorizationStatus() == .denied
    }
    
    func start(dataUpdates: @escaping (PedometerData?, Error?) -> Void, eventUpdates: @escaping (Error?) -> Void) {
        
        self.startEventUpdates { (event, error) in
            eventUpdates(error)
        }
        
        self.startUpdates(from: Date()) { (data, error) in
            dataUpdates(data, error)
        }
        
    }
    
}

extension CMPedometerData: PedometerData {
    
    var steps: Int {
        return self.numberOfSteps.intValue
    }
    
    var travelledDistance: Double {
        return self.distance?.doubleValue ?? 0
    }
    
}
