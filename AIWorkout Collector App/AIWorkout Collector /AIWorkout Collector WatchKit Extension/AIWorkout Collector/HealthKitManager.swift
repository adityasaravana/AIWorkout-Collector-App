//
//  HealthKitManager.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/23/21.
//

import HealthKit

class HealthKitManager {
    var description: String = ""
    
    var session: HKWorkoutSession!
    let healthStore = HKHealthStore()
    
    class var sharedInstance: HealthKitManager {
        struct Singleton {
            static let instance = HealthKitManager()
        }
        return Singleton.instance
    }
    
    private var isAuthorized: Bool? = false
    
    func authorizeHealthKit(completion: ((_ success: Bool) -> Void)!) {
        
    }
    
    func initWorkout(completion: ((_ success: Bool) -> Void)!) {
        let configuration = HKWorkoutConfiguration()
        
        let writableTypes: Set<HKSampleType> = []
        let readableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        
        // Request Authorization
        healthStore.requestAuthorization(toShare: writableTypes, read: readableTypes) { (success, error) in
            
            if success {
                completion(true)
                self.isAuthorized = true
            } else {
                completion(false)
                self.isAuthorized = false
                print("error authorizating HealthStore. \(String(describing: error?.localizedDescription))")
            }
        }
        
        configuration.activityType = .highIntensityIntervalTraining
        
        if session != nil {
            return
        }
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            
            
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
    }
    
    func start(completion: ((_ success: Bool) -> Void)!) {
        initWorkout(completion: completion)
        // Start the workout session
        
        session.startActivity(with: Date())
    }
    
    func stop() {
        // Stop the workout session
        session.stopActivity(with: Date())
        session.end()
        session = nil
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("[workoutSession] Encountered an error: \(error)")
    }
}


