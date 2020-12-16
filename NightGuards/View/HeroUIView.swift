//
//  HeroUIView.swift
//  NightGuards
//
//  Created by shy macbook on 11/25/20.
//

import SwiftUI
import CoreData

struct HeroUIView: View {
    @Binding var heroSelected: String
    @Binding var anchorPlaced: Bool
    var dataController: DataPersistController = DataPersistController()
    let heroes: Heroes
    
    init(heroSelected: Binding<String>, anchorPlaced: Binding<Bool>, heroes: Heroes) {
        _heroSelected = heroSelected
        _anchorPlaced = anchorPlaced
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
                self.heroSelected = "cone"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
                print("anchorPlaced:\t\(self.anchorPlaced)")
                if let hero = Heroes.heroDict[self.heroSelected] {
                    print(" * selected: \(hero.heroName)")
                    self.dataController.stageHeroUpdates(name: hero.heroName, id: hero.heroID, map: nil, unlocked: hero.heroUnlocked)
                }
			}.padding(10)
			HStack {
				Text("Kangaroo").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				Spacer()
				Image.init(systemName: "hare").scaleEffect(2)
			}.contentShape(Rectangle()).onTapGesture {
				print("kangaroo seleced")
                self.heroSelected = "kang"
                if let anchorStatus = Heroes.heroDict[heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
                print("anchorPlaced:\t\(self.anchorPlaced)")
                if let hero = Heroes.heroDict[self.heroSelected] {
                    print(" * selected: \(hero.heroName)")
                    self.dataController.stageHeroUpdates(name: hero.heroName, id: hero.heroID, map: nil, unlocked: hero.heroUnlocked)
                }
			}.padding(10)
		}
		.navigationBarTitle(Text("Guards"), displayMode: .inline)
	}
    
    func selectHero(hero: Hero) -> Bool {
        let heroUnlocked: Bool = true
        if heroUnlocked {
            print("hero unlocked")
//            heroSelected = heroName
//            dataController.stageHeroUpdates(name: heroName, id: nil, map: nil, unlocked: heroUnlocked)
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
