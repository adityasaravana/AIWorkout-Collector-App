//
//  ContentView.swift
//  AIWorkout Collector Template WatchKit Extension
//
//  Created by Aditya Saravana on 4/26/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationLink(
            destination: DataCollectorView(),
            label: {
                ZStack {
                    Circle()
                        .frame(width: 100.0, height: 100.0)
                        .foregroundColor(Color("SkyBlue"))
                    Text("Start".uppercased())
                        .font(.title2)
                        .foregroundColor(.white)
                }.padding(.all, 50)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

