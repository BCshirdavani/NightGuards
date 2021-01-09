//
//  HeroUIView.swift
//  NightGuards
//
//  Created by shy macbook on 11/25/20.
//

import SwiftUI
import SceneKit

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
                Text("Donut").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "smallcircle.fill.circle.fill").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = "donut"
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
                // TODO: redundant code with arViewContainer
                if let tumpAnimator = Animators.animeDict[self.heroSelected] {
                    print(" ~ ~ trump animator already exists")
                } else {
                    let trumpNode = SCNNode()
                    trumpNode.name = "trumpNode_heroUI"
                    let trumpAnimator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: trumpNode)
                    Animators.animeDict.updateValue(trumpAnimator, forKey: self.heroSelected)
                    if let trumpAnimator = Animators.animeDict["trump"] {
                        trumpAnimator.loadAnimations()
                    }
                }
            }.padding(10)
            HStack {
                Text("Lucha").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "staroflife").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = "lucha"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
                // TODO: redundant code with arViewContainer
                if let luchaAnimator = Animators.animeDict[self.heroSelected] {
                    print(" ~ ~ lucha animator already exists")
                } else {
                    let luchaNode = SCNNode()
                    luchaNode.name = "luchaNode_heroUI"
                    let luchaAnimator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: luchaNode)
                    Animators.animeDict.updateValue(luchaAnimator, forKey: self.heroSelected)
                    if let luchaAnimator = Animators.animeDict["lucha"] {
                        luchaAnimator.loadAnimations()
                    }
                }
            }.padding(10)
            HStack {
                Text("Ninja").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "staroflife").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = "ninja"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
                // TODO: redundant code with arViewContainer
                if let ninjaAnimator = Animators.animeDict[self.heroSelected] {
                    print(" ~ ~ ninja animator already exists")
                } else {
                    let ninjaNode = SCNNode()
                    ninjaNode.name = "ninjaNode_heroUI"
                    let ninjaAnimator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: ninjaNode)
                    Animators.animeDict.updateValue(ninjaAnimator, forKey: self.heroSelected)
                    if let ninjaAnimator = Animators.animeDict["ninja"] {
                        ninjaAnimator.loadAnimations()
                    }
                }
            }.padding(10)
            HStack {
                Text("Paladin").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "staroflife").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = "paladin"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
                // TODO: redundant code with arViewContainer
                if let paladinAnimator = Animators.animeDict[self.heroSelected] {
                    print(" ~ ~ paladin animator already exists")
                } else {
                    let paladinNode = SCNNode()
                    paladinNode.name = "paladinNode_heroUI"
                    let paladinAnimator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: paladinNode)
                    Animators.animeDict.updateValue(paladinAnimator, forKey: self.heroSelected)
                    if let paladinAnimator = Animators.animeDict["paladin"] {
                        paladinAnimator.loadAnimations()
                    }
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
