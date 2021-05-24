//
//  CustomViews.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/8/21.
//

import SwiftUI

struct ActionCircleView: View {
    let label: String
    let systemName: String
    let color: Color
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color.gray)
                
                Circle()
                    .frame(width: 110, height: 110)
                    .foregroundColor(color)
                Image(systemName: systemName)
                    .font(.system(size: 40))
            }.padding([.top, .leading, .trailing], 50)
            Text(label)
                .foregroundColor(.white)
                .font(.caption)
                .padding(.bottom, 50)
        }
    }
}

struct CircleLinkView: View {
    let systemName: String
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
            Image(systemName: systemName)
                .font(.system(size: 60))
        }.padding(.all, 0)
    }
}

struct LinkButton: View {
    @Binding var sheetIsPresented: Bool
    
    let actionType: ActionType
    let systemName: String
    
    var body: some View {
        Button {
            sheetIsPresented = true
        } label: {
            CircleLinkView(systemName: systemName)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $sheetIsPresented) {
            SessionView(actionType: actionType)
        }
    }
}


