//
//  ObservationSet.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

struct ObservationSet {
    
    private static let duplicationDistanceFraction = 0.5
    
    private(set) var observations = [ObservationNode]()
    
    mutating func add(_ observation: ObservationNode) {
        observations.append(observation)
    }
    
    mutating func uniquify(accordingTo observationSize: Double) {
        let duplicationDistance = observationSize * ObservationSet.duplicationDistanceFraction
        var newObservations = [ObservationNode]()
        
        for observation in observations {
            var shouldAdd = true
            for other in newObservations {
                if simd_distance(observation.position, other.position) < duplicationDistance {
                    shouldAdd = false
                    break
                }
            }
            
            if shouldAdd {
                newObservations.append(observation)
            }
        }
        
        observations = newObservations
    }
}
