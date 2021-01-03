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
    @Binding var mapName: String
    let heroes: Heroes
    
    init(heroSelected: Binding<String>, anchorPlaced: Binding<Bool>, heroes: Heroes, mapName: Binding<String>) {
        _heroSelected = heroSelected
        _anchorPlaced = anchorPlaced
        _mapName = mapName
        self.heroes = heroes
    }
    
	var body: some View {
		Text("Choose Guardian Here")
		List {
			HStack {
				Text("Ball").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				Spacer()
				Image.init(systemName: "circle.fill").scaleEffect(2)
			}.contentShape(Rectangle()).onTapGesture {
                heroSelected = "ball"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    anchorPlaced = anchorStatus
                }
			}.padding(10)
			HStack {
				Text("Cone").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				Spacer()
				Image.init(systemName: "arrowtriangle.up").scaleEffect(2)
			}.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = "cone"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
			}.padding(10)
			HStack {
				Text("Kangaroo").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				Spacer()
				Image.init(systemName: "hare").scaleEffect(2)
			}.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = "kang"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
			}.padding(10)
            HStack {
                Text("Trump").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "figure.walk").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = "trump"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
            }.padding(10)
		}
		.navigationBarTitle(Text("Guards"), displayMode: .inline)
	}
    
    func selectHero(hero: Hero) -> Bool {
        let heroUnlocked: Bool = true
        if heroUnlocked {
            print("hero unlocked")
            return true
        } else {
            print("hero unavailable, please purchase, or restore your purchases")
            return false
        }
    }

}

struct HeroUIView_Previews: PreviewProvider {
	static var previews: some View {
//        HeroUIView()
        Text("test")
	}
}
