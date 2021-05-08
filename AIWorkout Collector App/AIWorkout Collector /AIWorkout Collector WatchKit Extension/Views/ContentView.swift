//
//  ContentView.swift
//  AIWorkout Collector Template WatchKit Extension
//
//  Created by Aditya Saravana on 4/26/21.
//

import SwiftUI

struct ContentView: View {
    @State var sheetIsPresented = false
    @State var buttonSize = CGFloat(110)
    var body: some View {
        
        VStack {
            Button {
                sheetIsPresented = true
            } label: {
                ZStack {
                    Circle()
                        .frame(width: buttonSize + 10, height: buttonSize + 10)
                        .foregroundColor(Color.gray)
                    
                    
                    Circle()
                        .frame(width: buttonSize, height: buttonSize)
                        .foregroundColor(Color("SkyBlue"))
                    Image(systemName: "hammer.fill")
                        .font(.system(size: 40))
                }.padding(.all, 50)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $sheetIsPresented) {
                SessionView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

