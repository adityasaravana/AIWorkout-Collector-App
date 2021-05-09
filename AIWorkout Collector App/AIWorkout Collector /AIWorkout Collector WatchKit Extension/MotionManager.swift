
//
//  MotionManager.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 4/12/21.
//

import Foundation
import CoreMotion
import Combine

// MARK: - MotionManager Class
final class MotionManager: ObservableObject {
    let motionManager = CMMotionManager()
    
    @Published var accelerometerData: [[Double]] = []
    @Published var gyroData: [[Double]] = []
    @Published var deviceMotionData: [[Double]] = []
    
    @Published var mostRecentSession = Date()
}


// MARK: - MotionManager Functions

extension MotionManager {
    func start() {
        self.mostRecentSession = Date()
        
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
        }
        
        if gyroIsAvailable {
            motionManager.startGyroUpdates(to: .main) { (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                let timeStamp = Double((Date().timeIntervalSince1970) * 1000)
                
                self.gyroData.append([data.rotationRate.x, data.rotationRate.y, data.rotationRate.z, timeStamp])
                print(data)
            }
        }
        
        if deviceMotionIsAvailible {
            motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                let timeStamp = Double((Date().timeIntervalSince1970) * 1000)
                
                self.deviceMotionData.append([data.attitude.quaternion.w, data.attitude.quaternion.x, data.attitude.quaternion.y, data.attitude.quaternion.z, data.attitude.pitch, data.attitude.roll, data.attitude.yaw, timeStamp])
                print(data)
            }
        }
    }
    
    
    func save() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let motionData: [[[Double]]: String] = [
            accelerometerData: "AccelerometerData",
            gyroData: "GyroData",
            deviceMotionData: "DeviceMotionData",
            
        ]
        
        do {
            let sessionID = UUID().uuidString
            let plistURL = URL(fileURLWithPath: "MotionData-\(sessionID)", relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("plist")
            let data = try encoder.encode(motionData)
            try data.write(to: plistURL, options: .atomicWrite)
        } catch let error {
            print(error)
        }
        
    }
    
    func upload(fileName: URL, actionType: ActionType) {
        #warning("Add content")
        //Upload
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
        save()
        accelerometerData = []
        gyroData = []
        deviceMotionData = []
    }
}

// MARK: - Extensions

public extension FileManager {
    static var documentsDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}


// MARK: - MotionManager Buttons

import SwiftUI


struct StartButton: View {
    @Binding var testingPhase: TestingPhase
    let motionManager = MotionManager()
    var body: some View {
        Button {
            motionManager.start()
            testingPhase = .inProgress
        } label: {
            ActionCircleView(systemName: "play.fill", color: .green)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct RecordButton: View {
    @Binding var testingPhase: TestingPhase
    let motionManager = MotionManager()
    var body: some View {
        Button {
            testingPhase = .recordingInProgress
        } label: {
            ActionCircleView(systemName: "video.fill", color: .red)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct StopButton: View {
    @Binding var testingPhase: TestingPhase
    let motionManager = MotionManager()
    var body: some View {
        Button {
            //                motionManager.stop()
            testingPhase = .uploading
        } label: {
            ActionCircleView(systemName: "pause.fill", color: .orange)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct UploadButton: View {
    @Binding var testingPhase: TestingPhase
    let motionManager = MotionManager()
    
    var actionType: ActionType
    var body: some View {
        Button {
            #warning("Add an actual filename")
            motionManager.upload(fileName: URL(string: "")!, actionType: actionType)
            testingPhase = .finished
        } label: {
            ActionCircleView(systemName: "icloud.and.arrow.up.fill", color: .blue)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct FinishButton: View {
    @Binding var testingPhase: TestingPhase
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            ActionCircleView(systemName: "checkmark", color: .green)
        }.buttonStyle(PlainButtonStyle())
    }
}


// MARK: - Enumurations

enum TestingPhase {
    case notStarted
    case inProgress
    case recordingInProgress
    case uploading
    case finished
}

enum ActionType {
    case jump
    case duck
    case dodgeRight
    case dodgeLeft
}
