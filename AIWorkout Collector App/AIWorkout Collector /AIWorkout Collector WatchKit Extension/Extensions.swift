//
//  Extensions.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/23/21.
//

import Foundation

// MARK: - Extensions

public extension FileManager {
    static var documentsDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

// MARK: - Enumurations

enum TestingPhase {
    case notStarted
    case inProgress
    case recordingInProgress
    case finished
}

enum ActionType {
    case jump
    case duck
    case dodgeRight
    case dodgeLeft
}
