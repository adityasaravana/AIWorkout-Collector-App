//
//  SessionView.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/7/21.
//

import SwiftUI


struct SessionView: View {
    @State var currentTestingPhase = TestingPhase.notStarted
    
    var actionType: ActionType
    
    var body: some View {
        if currentTestingPhase == .notStarted {
            StartButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .inProgress {
            RecordButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .recordingInProgress {
            StopButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .uploading {
            UploadButton(testingPhase: $currentTestingPhase, actionType: actionType)
        } else if currentTestingPhase == .finished {
            FinishButton(testingPhase: $currentTestingPhase)
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(actionType: .dodgeLeft)
    }
}
