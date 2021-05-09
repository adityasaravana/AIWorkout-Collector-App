//
//  StartView.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/8/21.
//

import SwiftUI

struct StartView: View {
    var actionType: ActionType
    
    @State var sheetIsPresented = false
    
    var body: some View {
        VStack {
            Button {
                sheetIsPresented = true
            } label: {
                ActionCircleView(systemName: "hammer.fill", color: Color("SkyBlue"))
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $sheetIsPresented) {
                SessionView(actionType: actionType)
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StartView(actionType: .jump)
        }
    }
}

