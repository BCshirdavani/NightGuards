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
    let purchaser: Purchaser
    @State var showAlert = false
    @State var alertLucha = false
    @State var alertNinja = false
    @State var alertTrump = false
    
    init(heroSelected: Binding<String>, anchorPlaced: Binding<Bool>, heroes: Heroes, mapName: Binding<String>) {
        _heroSelected = heroSelected
        _anchorPlaced = anchorPlaced
        _mapName = mapName
        self.purchaser = Purchaser()
        self.heroes = heroes
    }
    
    var body: some View {
        VStack {
            List {
                // MARK: donut
                HStack {
                    HeroCard(cardName: K.DONUT, price: "FREE", unlocked: true, placed: (Heroes.heroDict[K.DONUT]?.isPlaced())!)
                }.contentShape(Rectangle()).onTapGesture {
                    self.heroSelected = K.DONUT
                    if let anchorStatus = Heroes.heroDict[self.heroSelected]?.isPlaced() {
                        self.anchorPlaced = anchorStatus
                    }
                }
                .listRowBackground(self.heroSelected == K.DONUT ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground))
                
                // MARK: paladin
                HStack {
                    HeroCard(cardName: K.PALADIN, price: "FREE", unlocked: true, placed: (Heroes.heroDict[K.PALADIN]?.isPlaced())!)
                }.contentShape(Rectangle()).onTapGesture {
                    heroSelectionHandler(heroName: K.PALADIN, available: true)
                }.padding(2)
                .listRowBackground(self.heroSelected == K.PALADIN ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground))
                
                // MARK: lucha
                HStack {
                    HeroCard(cardName: K.LUCHA, price: "0.99", unlocked: false, placed: (Heroes.heroDict[K.LUCHA]?.isPlaced())!)
                }.contentShape(Rectangle()).onTapGesture {
                    let available: Bool = checkPurchaseStatus(itemName: K.LUCHA)
                    if available {
                        heroSelectionHandler(heroName: K.LUCHA, available: available)
                    }
                }.padding(2)
                .listRowBackground(self.heroSelected == K.LUCHA ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground))
                .alert(isPresented: self.$alertLucha) { () -> Alert in
                    buyAlert(heroName: K.LUCHA)
                }
                
                // MARK: ninja
                HStack {
                    HeroCard(cardName: K.NINJA, price: "0.99", unlocked: false, placed: (Heroes.heroDict[K.NINJA]?.isPlaced())!)
                }.contentShape(Rectangle()).onTapGesture {
                    let available: Bool = checkPurchaseStatus(itemName: K.NINJA)
                    if available {
                        heroSelectionHandler(heroName: K.NINJA, available: available)
                    }
                }.padding(2)
                .listRowBackground(self.heroSelected == K.NINJA ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground))
                .alert(isPresented: self.$alertNinja) { () -> Alert in
                    buyAlert(heroName: K.NINJA)
                }
                
                // MARK: trump
                HStack {
                    HeroCard(cardName: K.TRUMP, price: "0.99", unlocked: false, placed: (Heroes.heroDict[K.TRUMP]?.isPlaced())!)
                }.contentShape(Rectangle()).onTapGesture {
                    let available: Bool = checkPurchaseStatus(itemName: K.TRUMP)
                    if available {
                        heroSelectionHandler(heroName: K.TRUMP, available: available)
                    }
                }.padding(2)
                .listRowBackground(self.heroSelected == K.TRUMP ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground))
                .alert(isPresented: self.$alertTrump) { () -> Alert in
                    buyAlert(heroName: K.TRUMP)
                }
            }
        }
        .navigationBarTitle(Text("Guards"), displayMode: .inline)
    }
    
    func heroSelectionHandler(heroName: String, available: Bool) {
        self.heroSelected = heroName
        Heroes.heroDict[self.heroSelected]?.heroUnlocked = available
        if let anchorStatus = Heroes.heroDict[self.heroSelected]?.isPlaced() {
            self.anchorPlaced = anchorStatus
        }
        // TODO: redundant code with arViewContainer
        if let animator = Animators.animeDict[self.heroSelected] {
            print(" ~ ~ trump animator already exists")
        } else {
            let node = SCNNode()
            node.name = "\(heroName)Node_heroUI"
            let animator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: node)
            Animators.animeDict.updateValue(animator, forKey: self.heroSelected)
            if let animator = Animators.animeDict[heroName] {
                animator.loadAnimations()
            }
        }
    }
    
    func selectHero(hero: Hero) -> Bool {
        let heroUnlocked: Bool = self.purchaser.isPurchased(itemName: hero.heroName)
        if heroUnlocked {
            print("hero unlocked")
            return true
        } else {
            print("hero unavailable, please purchase, or restore your purchases")
            return false
        }
    }
    
    func checkPurchaseStatus(itemName: String) -> Bool {
        print("------------------------------")
        Heroes.heroDict.values.forEach { (hero) in
            print(" - \(hero.heroName) unlocked: \(hero.heroUnlocked)")
        }
        print(Heroes.heroDict)
        let available: Bool = self.purchaser.isPurchased(itemName: itemName) || Heroes.heroDict[itemName]!.heroUnlocked
        if available {
            print(" = = available")
            showAlert = false
            return true
        } else {
            showAlert = true
            if itemName == K.LUCHA {
                alertLucha = true
            } else if itemName == K.NINJA {
                alertNinja = true
            } else if itemName == K.TRUMP {
                alertTrump = true
            }
            return false
        }
    }
    
    func buyAlert(heroName: String) -> Alert {
        let alert = Alert(title: Text("Purchase \(heroName) for $0.99?"), primaryButton: .default(Text("Buy"), action: {
            self.purchaser.buyHero(hero: heroName)
        }), secondaryButton: .cancel(Text("Exit")))
        return alert
    }

}

struct HeroUIView_Previews: PreviewProvider {
	static var previews: some View {
//        HeroUIView(heroSelected: <#Binding<String>#>, anchorPlaced: <#Binding<Bool>#>, heroes: <#Heroes#>, mapName: <#Binding<String>#>)
        Text("test")
	}
}
