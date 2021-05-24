//
//  SessionView.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/7/21.
//

import SwiftUI

struct SessionView: View {
    @State var currentTestingPhase = TestingPhase.notStarted
    
    let actionType: ActionType
    
    var body: some View {
        if currentTestingPhase == .notStarted {
            StartButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .inProgress {
            RecordButton(testingPhase: $currentTestingPhase)
        } else if currentTestingPhase == .recordingInProgress {
            FinishButton(testingPhase: $currentTestingPhase, actionType: actionType)
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(actionType: .dodgeLeft)
    }
}

// MARK: - Buttons

private let motionManager = MotionManager()
private let healthKitManager = HealthKitManager()

struct StartButton: View {
    @Binding var testingPhase: TestingPhase
    
    var body: some View {
        Button {
            testingPhase = .inProgress
        } label: {
            ActionCircleView(label: "Start", systemName: "play.fill", color: .blue)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct RecordButton: View {
    @Binding var testingPhase: TestingPhase
    
    var body: some View {
        Button {
            healthKitManager.start { success in
                if success {
                    motionManager.start()
                    testingPhase = .recordingInProgress
                } else {
                    print("Error starting HealthKitManager")
                }
            }
        } label: {
            ActionCircleView(label: "Record", systemName: "video.fill", color: .red)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct FinishButton: View {
    @Binding var testingPhase: TestingPhase
    @Environment(\.presentationMode) var presentationMode
    
    let actionType: ActionType
    
    var body: some View {
        Button {
            motionManager.stop(actionType: actionType)
            healthKitManager.stop()
            presentationMode.wrappedValue.dismiss()
        } label: {
            ActionCircleView(label: "Finish", systemName: "checkmark", color: .green)
        }.buttonStyle(PlainButtonStyle())
    }
}
