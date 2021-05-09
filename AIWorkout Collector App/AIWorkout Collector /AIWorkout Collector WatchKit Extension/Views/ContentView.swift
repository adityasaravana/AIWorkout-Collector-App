//
//  ContentView.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 4/26/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                LinkButton(actionType: .jump, systemName: "arrow.up")
                
                LinkButton(actionType: .dodgeRight, systemName: "arrow.right")
            }.padding(.top)
            HStack {
                LinkButton(actionType: .dodgeLeft, systemName: "arrow.left")
                
                LinkButton(actionType: .duck, systemName: "arrow.down")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            CircleLinkView(systemName: "arrow.left")
        }
    }
}

struct LinkButton: View {
    var actionType: ActionType
    var systemName: String
    var body: some View {
        NavigationLink(
            destination: StartView(actionType: actionType),
            label: {
                CircleLinkView(systemName: systemName)
            }).buttonStyle(PlainButtonStyle())
    }
}
