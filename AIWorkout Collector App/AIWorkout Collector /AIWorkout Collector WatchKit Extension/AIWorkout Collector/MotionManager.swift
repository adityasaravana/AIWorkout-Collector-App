
//
//  MotionManager.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 4/12/21.
//

import Foundation
import CoreMotion
import Combine
import HealthKit

// MARK: - MotionManager Class
final class MotionManager: ObservableObject {
    let motionManager = CMMotionManager()

    let serverManager = ServerManager()
    var isSimulator = false
    @Published var accelerometerData: [[Double]] = []
    @Published var gyroData: [[Double]] = []
    @Published var deviceMotionData: [[Double]] = []
    
    @Published var mostRecentSession = Date()
    
    @Published var fileName = ""

}


// MARK: - MotionManager Functions

extension MotionManager {
    
    func start() {
        self.mostRecentSession = Date()
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.accelerometerUpdateInterval = 0.01    
        let motionIsAvailible = motionManager.isAccelerometerAvailable
        let gyroIsAvailable = motionManager.isGyroAvailable
        let deviceMotionIsAvailible = motionManager.isDeviceMotionAvailable
        if motionIsAvailible {
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                
                let timeStamp = Double((Date().timeIntervalSince1970) * 1000)
                self.accelerometerData.append([data.acceleration.x, data.acceleration.y, data.acceleration.z, timeStamp])
                print(data)
            }
        } else {
            isSimulator = true
            //self.accelerometerData.append([Double.random(in: 0...1), Double.random(in: 0...1), Double.random(in: 0...1), timeStamp])
            
        }
        
        if gyroIsAvailable {
            motionManager.startGyroUpdates(to: .main) { (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                print(error ?? "Error printing error")
                let timeStamp = Double((Date().timeIntervalSince1970) * 1000)
                
                self.gyroData.append([data.rotationRate.x, data.rotationRate.y, data.rotationRate.z, timeStamp])
                print(data)
            }
        } else {
            //self.gyroData.append([Double.random(in: 0...1), Double.random(in: 0...1), Double.random(in: 0...1), timeStamp])
            
        }
        
        if deviceMotionIsAvailible {
            motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                let timeStamp = Double((Date().timeIntervalSince1970) * 1000)
                
                self.deviceMotionData.append([data.attitude.quaternion.w, data.attitude.quaternion.x, data.attitude.quaternion.y, data.attitude.quaternion.z, data.attitude.pitch, data.attitude.roll, data.attitude.yaw, timeStamp])
            }
        } else {
            //self.deviceMotionData.append([Double.random(in: 0...1), Double.random(in: 0...1), Double.random(in: 0...1), timeStamp])
            
        }
    }
    
    
    func save(actionType: ActionType) {
        let fileLabel = "\(actionType)".uppercased()
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print(fileLabel)
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let motionData: [String : [[Double]]] = [
            "AccelerometerData": accelerometerData,
            "GyroData": gyroData,
            "DeviceMotionData": deviceMotionData
        ]
        
        var tag = ""
        if (isSimulator) {
            tag = "SIM"
        } else {
            tag = "DEV"
        }
        
        do {
            let sessionID = UUID().uuidString
            fileName = "MotionData-\(sessionID)-\(fileLabel)-\(tag).plist"
            let plistURL = URL(fileURLWithPath: fileName, relativeTo: FileManager.documentsDirectoryURL)
            let data = try encoder.encode(motionData)
            try data.write(to: plistURL, options: .atomicWrite)
        } catch let error {
            print(error)
        }
        
    }
    
    func upload(completion: ((_ success: Bool) -> Void)!) {
        serverManager.sendPostRequest(fileName: fileName, completion: completion)
    }
    
    func stop(actionType: ActionType) {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
        save(actionType: actionType)
        upload { success in
            if success {
                print("Upload successful")
            } else {
                print("Error starting HealthKitManager")
            }
        }
        
        accelerometerData = []
        gyroData = []
        deviceMotionData = []
    }
}

