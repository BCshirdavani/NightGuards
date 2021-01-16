//
//  ActionButtonView.swift
//  NightGuards
//
//  Created by shiMac on 12/16/20.
//

import SwiftUI

struct ActionButtonView: View {
    let arDisplayView: ARDisplayView
    let arViewContainer: ARViewContainer
    @Binding var anchorPlaced: Bool
    
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 60, height: 60, alignment: .center)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                .foregroundColor(.blue)
            anchorPlaced ? Image(systemName: "move.3d")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .medium)) : Image(systemName: "mappin.and.ellipse")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .medium))
        }
    }
    
    func buttonText() -> String {
            return anchorPlaced ? "move" : "place"
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
//        ActionButtonView()
        Image.init(systemName: "arrow.clockwise.circle.fill").foregroundColor(.white).scaleEffect(3.0)
        Text("test")
    }
}
