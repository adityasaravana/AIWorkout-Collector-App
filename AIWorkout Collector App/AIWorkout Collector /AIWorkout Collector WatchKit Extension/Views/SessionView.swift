//
//  SessionView.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/7/21.
//

import SwiftUI

enum TestingPhase {
    case notStarted
    case inProgress
    case recordingInProgress
    case uploading
    case finished
}

struct SessionView: View {
    
    
    @State var currentTestingPhase = TestingPhase.notStarted
    var body: some View {
        if currentTestingPhase == .notStarted {
            MotionManager.StartButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .inProgress {
            MotionManager.RecordButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .recordingInProgress {
            MotionManager.StopButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .uploading {
            MotionManager.UploadButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .finished {
            MotionManager.FinishButton(testingPhase: $currentTestingPhase)
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
