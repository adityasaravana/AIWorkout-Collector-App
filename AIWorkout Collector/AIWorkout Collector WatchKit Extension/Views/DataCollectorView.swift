//
//  DataCollectorView.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 4/12/21.
//
import SwiftUI

struct DataCollectorView: View {
    let motionManager = MotionManager()
    
    enum TestingPhase {
        case notStarted
        case inProgress
        case recordingInProgress
        case finished
    }
    
    @State var initalized = false
    @State var currentTestingPhase = TestingPhase.notStarted
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                if currentTestingPhase == .notStarted {
                    ///Start accelerometer and change testing phase to in progress
                    motionManager.start()
                    initalized = true
                    
                    currentTestingPhase = .inProgress
                    
                } else if currentTestingPhase == .inProgress {
                    currentTestingPhase = .recordingInProgress
                } else if currentTestingPhase == .recordingInProgress {
                    motionManager.stop()
                    currentTestingPhase = .finished
                }
            } label: {
                if currentTestingPhase == .notStarted {
                    Text("Begin")
                } else if currentTestingPhase == .inProgress {
                    Text("Record")
                } else if currentTestingPhase == .recordingInProgress {
                    Text("Finish")
                } else if currentTestingPhase == .finished {
                    Text("All Done").disabled(true)
                }
            }
            Spacer()
        }
    }
}

struct DataCollectorView_Previews: PreviewProvider {
    static var previews: some View {
        DataCollectorView()
    }
}
