//
//  MotionManagerButtons.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/20/21.
//

import SwiftUI
import HealthKit

private let motionManager = MotionManager()
private let healthKitManager = HealthKitManager()

struct StartButton: View {
    @Binding var testingPhase: TestingPhase
    
    var body: some View {
        Button {
//            healthKitManager.start()
            motionManager.start()
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
            testingPhase = .recordingInProgress
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
