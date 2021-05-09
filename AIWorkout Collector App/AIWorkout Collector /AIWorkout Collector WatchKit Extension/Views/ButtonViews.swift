//
//  CustomViews.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/8/21.
//

import SwiftUI

struct ActionCircleView: View {
    var systemName: String
    var color: Color
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 120, height: 120)
                .foregroundColor(Color.gray)
            
            Circle()
                .frame(width: 110, height: 110)
                .foregroundColor(color)
            Image(systemName: systemName)
                .font(.system(size: 40))
        }.padding(.all, 50)
    }
}

struct CircleLinkView: View {
    var systemName: String
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


struct ButtonViews_Previews: PreviewProvider {
    static var previews: some View {
        ActionCircleView(systemName: "hammer.fill", color: .blue)
        ActionCircleView(systemName: "video.fill", color: .red)
    }
}

