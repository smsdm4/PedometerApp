//
//  PedometerViewModel.swift
//  PedometerApp
//
//  Created by Mojtaba Mirzadeh on 8/13/22.
//

import Foundation
import CoreMotion

enum AppState {
    case notStarted
    case inProgress
    case notAuthorized
}

class PedometerViewModel {
    
    var steps: Int = 0
    var travelledDistance: Double = 0.0
    
    var pedometer: Pedometer
    var appState: AppState = .notStarted
    
    init(pedometer: Pedometer) {
        self.pedometer = pedometer
    }
    
    func startPedometer() {
        
        guard self.pedometer.pedometerAvailable else {
            self.appState = .notStarted
            return
        }
        
        guard !self.pedometer.permisionDeclined else {
            self.appState = .notStarted
            return
        }
        
        self.appState = .inProgress
        
        self.pedometer.start(dataUpdates: { (data, error) in
            if let data = data {
                self.steps = data.steps
                self.travelledDistance = data.travelledDistance
            }
        }, eventUpdates: { error in
            if let error = error {
                let nsError = error as NSError
                if nsError.domain == CMErrorDomain && nsError.code == CMErrorMotionActivityNotAuthorized.rawValue {
                    self.appState = .notAuthorized
                }
            }
        })
        
    }
    
}
