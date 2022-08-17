//
//  Pedometer.swift
//  PedometerApp
//
//  Created by Mojtaba Mirzadeh on 8/13/22.
//

import Foundation

protocol Pedometer {
    
    var pedometerAvailable: Bool { get }
    var permisionDeclined: Bool { get }
    
    func start(dataUpdates: @escaping (PedometerData?, Error?) -> Void, eventUpdates: @escaping (Error?) -> Void)
    
}

protocol PedometerData {
    
    var steps: Int { get }
    var travelledDistance: Double { get  }
    
}
