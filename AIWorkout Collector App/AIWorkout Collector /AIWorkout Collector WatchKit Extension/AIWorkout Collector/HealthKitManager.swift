//
//  HealthKitManager.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/23/21.
//

import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    func request() {
        if HKHealthStore.isHealthDataAvailable() {
            let heartRateQuantityType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let allTypes = Set([HKObjectType.workoutType(),
                                heartRateQuantityType
            ])
            healthStore.requestAuthorization(toShare: nil, read: allTypes) { (result, error) in
                if let error = error {
                    // deal with the error
                    print(error.localizedDescription)
                    return
                }
                guard result else {
                    // deal with the failed request
                    return
                }
                // begin any necessary work if needed
            }
        }
    }
    
    //    func startWorkoutWithHealthStore() -> HKWorkoutSession {
    //        let configuration = HKWorkoutConfiguration()
    //        configuration.activityType = HKWorkoutActivityType.highIntensityIntervalTraining
    //
    //        let session : HKWorkoutSession
    //        do {
    //            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
    //        } catch let error {
    //            // let the user know about the error
    //            return
    //        }
    //
    //
    //        return session
    //    }
    
    func stop() {
        
    }
}


