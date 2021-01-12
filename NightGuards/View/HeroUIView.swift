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
		Text("Choose Guardian Here")
		List {
            // MARK: donut
            HStack {
                Text(K.DONUT).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "smallcircle.fill.circle.fill").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = K.DONUT
                if let anchorStatus = Heroes.heroDict[self.heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
            }.padding(10)
            .listRowBackground(self.heroSelected == K.DONUT ? Color(UIColor.red) : Color(UIColor.systemBackground))
            // MARK: paladin
            HStack {
                Text(K.PALADIN).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "staroflife").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                self.heroSelected = K.PALADIN
                if let anchorStatus = Heroes.heroDict[self.heroSelected]?.isPlaced() {
                    self.anchorPlaced = anchorStatus
                }
                if let paladinAnimator = Animators.animeDict[self.heroSelected] {
                    print(" ~ ~ paladin animator already exists")
                } else {
                    let paladinNode = SCNNode()
                    paladinNode.name = "\(K.PALADIN)Node_heroUI"
                    let paladinAnimator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: paladinNode)
                    Animators.animeDict.updateValue(paladinAnimator, forKey: self.heroSelected)
                    if let paladinAnimator = Animators.animeDict[K.PALADIN] {
                        paladinAnimator.loadAnimations()
                    }
                }
            }.padding(10)
            .listRowBackground(self.heroSelected == K.PALADIN ? Color(UIColor.red) : Color(UIColor.systemBackground))
            // MARK: lucha
            HStack {
                Text(K.LUCHA).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "staroflife").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                let available: Bool = checkPurchaseStatus(itemName: K.LUCHA)
                if available {
                    self.heroSelected = K.LUCHA
                    Heroes.heroDict[self.heroSelected]?.heroUnlocked = available
                    if let anchorStatus = Heroes.heroDict[self.heroSelected]?.isPlaced() {
                        self.anchorPlaced = anchorStatus
                    }
                    // TODO: redundant code with arViewContainer
                    if let luchaAnimator = Animators.animeDict[self.heroSelected] {
                        print(" ~ ~ lucha animator already exists")
                    } else {
                        let luchaNode = SCNNode()
                        luchaNode.name = "\(K.LUCHA)Node_heroUI"
                        let luchaAnimator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: luchaNode)
                        Animators.animeDict.updateValue(luchaAnimator, forKey: self.heroSelected)
                        if let luchaAnimator = Animators.animeDict[K.LUCHA] {
                            luchaAnimator.loadAnimations()
                        }
                    }
                }
            }.padding(10)
            .listRowBackground(self.heroSelected == K.LUCHA ? Color(UIColor.red) : Color(UIColor.systemBackground))
            .alert(isPresented: self.$alertLucha) { () -> Alert in
                buyAlert(heroName: K.LUCHA)
            }
            // MARK: ninja
            HStack {
                Text(K.NINJA).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "staroflife").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                let available: Bool = checkPurchaseStatus(itemName: K.NINJA)
                if available {
                    self.heroSelected = K.NINJA
                    Heroes.heroDict[self.heroSelected]?.heroUnlocked = available
                    if let anchorStatus = Heroes.heroDict[self.heroSelected]?.isPlaced() {
                        self.anchorPlaced = anchorStatus
                    }
                    // TODO: redundant code with arViewContainer
                    if let ninjaAnimator = Animators.animeDict[self.heroSelected] {
                        print(" ~ ~ ninja animator already exists")
                    } else {
                        let ninjaNode = SCNNode()
                        ninjaNode.name = "\(K.NINJA)Node_heroUI"
                        let ninjaAnimator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: ninjaNode)
                        Animators.animeDict.updateValue(ninjaAnimator, forKey: self.heroSelected)
                        if let ninjaAnimator = Animators.animeDict[K.NINJA] {
                            ninjaAnimator.loadAnimations()
                        }
                    }
                }
            }.padding(10)
            .listRowBackground(self.heroSelected == K.NINJA ? Color(UIColor.red) : Color(UIColor.systemBackground))
            .alert(isPresented: self.$alertNinja) { () -> Alert in
                buyAlert(heroName: K.NINJA)
            }
            // MARK: trump
            HStack {
                Text(K.TRUMP).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Image.init(systemName: "figure.walk").scaleEffect(2)
            }.contentShape(Rectangle()).onTapGesture {
                let available: Bool = checkPurchaseStatus(itemName: K.TRUMP)
                if available {
                    self.heroSelected = K.TRUMP
                    Heroes.heroDict[self.heroSelected]?.heroUnlocked = available
                    if let anchorStatus = Heroes.heroDict[self.heroSelected]?.isPlaced() {
                        self.anchorPlaced = anchorStatus
                    }
                    // TODO: redundant code with arViewContainer
                    if let tumpAnimator = Animators.animeDict[self.heroSelected] {
                        print(" ~ ~ trump animator already exists")
                    } else {
                        let trumpNode = SCNNode()
                        trumpNode.name = "\(K.TRUMP)Node_heroUI"
                        let trumpAnimator = Animator(heroToAnimate: Heroes.heroDict[self.heroSelected]!, sceneNode: trumpNode)
                        Animators.animeDict.updateValue(trumpAnimator, forKey: self.heroSelected)
                        if let trumpAnimator = Animators.animeDict[K.TRUMP] {
                            trumpAnimator.loadAnimations()
                        }
                    }
                }
            }.padding(10)
            .listRowBackground(self.heroSelected == K.TRUMP ? Color(UIColor.red) : Color(UIColor.systemBackground))
            .alert(isPresented: self.$alertTrump) { () -> Alert in
                buyAlert(heroName: K.TRUMP)
            }
		}
		.navigationBarTitle(Text("Guards"), displayMode: .inline)
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
//        HeroUIView()
        Text("test")
	}
}
