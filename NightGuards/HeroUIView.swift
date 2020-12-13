//
//  HeroUIView.swift
//  NightGuards
//
//  Created by shy macbook on 11/25/20.
//

import SwiftUI

struct HeroUIView: View {
    @Binding var heroSelected: String
    @Binding var anchorPlaced: Bool
//    let heroes: Heroes = Heroes()
    
	var body: some View {
		Text("Choose Guardian Here")
		List {
			HStack {
				Text("Ball").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				Spacer()
				Image.init(systemName: "circle.fill").scaleEffect(2)
			}.contentShape(Rectangle()).onTapGesture {
				print("ball selected")
                heroSelected = "ball"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    anchorPlaced = anchorStatus
                }
                print("anchorPlaced:\t\(anchorPlaced)")
			}.padding(10)
			HStack {
				Text("Cone").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				Spacer()
				Image.init(systemName: "arrowtriangle.up").scaleEffect(2)
			}.contentShape(Rectangle()).onTapGesture {
				print("cone seleced")
                heroSelected = "cone"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    anchorPlaced = anchorStatus
                }
                print("anchorPlaced:\t\(anchorPlaced)")
			}.padding(10)
			HStack {
				Text("Kangaroo").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				Spacer()
				Image.init(systemName: "hare").scaleEffect(2)
			}.contentShape(Rectangle()).onTapGesture {
				print("kangaroo seleced")
                heroSelected = "kang"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    anchorPlaced = anchorStatus
                }
                print("anchorPlaced:\t\(anchorPlaced)")
			}.padding(10)
		}
		.navigationBarTitle(Text("Guards"), displayMode: .inline)
	}
}

struct HeroUIView_Previews: PreviewProvider {
	static var previews: some View {
//        HeroUIView()
        Text("test")
	}
}
