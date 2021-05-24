//
//  ContentView.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 4/26/21.
//

import SwiftUI

struct ContentView: View {
    @State var sheetIsPresented = false
    var body: some View {
        VStack {
            HStack {
                LinkButton(sheetIsPresented: $sheetIsPresented, actionType: .jump, systemName: "arrow.up")
                
                LinkButton(sheetIsPresented: $sheetIsPresented, actionType: .dodgeRight, systemName: "arrow.right")
            }.padding(.top, 20)
            HStack {
                LinkButton(sheetIsPresented: $sheetIsPresented, actionType: .dodgeLeft, systemName: "arrow.left")
                
                LinkButton(sheetIsPresented: $sheetIsPresented, actionType: .duck, systemName: "arrow.down")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

