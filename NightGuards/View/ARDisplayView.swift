//
//  ARDisplayView.swift
//  NightGuards
//
//  Created by shy macbook on 11/18/20.
//

import SwiftUI
import RealityKit
import ARKit

struct ARDisplayView: View {
    
	let arViewContainer: ARViewContainer
	@State private var anchorPlaced: Bool = false
    @State private var heroSelected: String = "none"
    @State private var camStringStat: String = ""
    @State private var mapName: String = "alpha"
    @State private var roomIndex: Int = 0
    @State private var showButtons: Bool = true
    private let roomArray = ["alpha", "bravo", "charlie"]
    let heroes: Heroes = Heroes()
    let dataController: DataPersistController = DataPersistController()
    let arScnView: ARSCNView

	init() {
		self.arViewContainer = ARViewContainer()
        self.arScnView = ARSCNView()
	}

    var body: some View {
		ZStack {
            arViewContainer.onTapGesture {
                setCamStatus()
            }.gesture(DragGesture(minimumDistance: 5.0, coordinateSpace: .local).onEnded({ (value) in
                if value.translation.width < -100 {
                    roomIndex -= 1
                    switchRoom()
                }
                else if value.translation.width > 100 {
                    roomIndex += 1
                    switchRoom()
                }
                else if value.translation.height < -100 {
                    withAnimation{
                        showButtons = true
                    }
                }
                else if value.translation.height > 100 {
                    withAnimation{
                        showButtons = false
                    }
                }
            })).onDisappear {
                arViewContainer.saveMap()
            }
            VStack {
                HStack {
                    Image.init(systemName: "bed.double.fill").padding([.leading, .top], 5.0)
                    Text("Loc: \(mapName)").padding([.top], 5.0)
                    Spacer()
                }
                Spacer()
                if showButtons {
                    HStack{
                        ActionButtonView(arDisplayView: self, arViewContainer: arViewContainer, anchorPlaced: $anchorPlaced)
                            .onTapGesture {
                                self.placeHero(position: arViewContainer.arScnView.center, object: heroSelected)
                            }
                        Spacer()
                        ZStack{
                            Circle()
                                .frame(width: 60, height: 60, alignment: .center)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                                .foregroundColor(.pink)
                                .onTapGesture {
                                    resetMap()
                                }
                            Text("reset").foregroundColor(.white)
                        }
                        Spacer()
                        NavigationLink(destination: HeroUIView(heroSelected: $heroSelected, anchorPlaced: $anchorPlaced, heroes: heroes, mapName: $mapName)) {
                            ZStack {
                                Circle()
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                                    .foregroundColor(.black)
                                Text(heroSelected).foregroundColor(.white)
                                
                            }
                        }
                    }.transition(.move(edge: .bottom))
                    
                }
            }
        }
    }
    
    func resetMap() {
        Heroes.heroDict.keys.forEach { (hero) in
            Heroes.heroDict[hero]?.heroMapURLString = nil
            dataController.stageHeroUpdates(name: hero, map: nil, unlocked: true)
        }
        arViewContainer.killAllARAnchors()
        arViewContainer.configAR()
    }
    
    func switchRoom(){
        let roomCount = roomArray.count
        var newIndex: Int
        if roomIndex >= 0 {
            newIndex = roomIndex % roomCount
        } else {
            newIndex = (roomIndex % roomCount + roomCount) % roomCount
        }
        mapName = roomArray[newIndex]
    }
    
    func placeHero(position: CGPoint, object: String) {
        if object != "none" {
            arViewContainer.castRaySimple(point: position, object: object)
            if let hero = Heroes.heroDict[object] {
                anchorPlaced = hero.isPlaced()
            }
//            self.dataController.stageHeroUpdates(name: heroSelected, map: mapName, unlocked: true)
        }
    }

	func buttonText() -> String {
        if Heroes.heroDict[heroSelected] != nil {
            return anchorPlaced ? "move" : "place"
        }
        return "..."
	}
    
    // TODO: figure out how to mutate the @State property to update with tracking status
    func setCamStatus() {
        if let trackState = arViewContainer.arScnView.session.currentFrame?.camera.trackingState {
            switch trackState {
            case .normal:
                camStringStat = "normal"
            case .notAvailable:
                camStringStat = "N/A"
            case .limited(.excessiveMotion):
                camStringStat = "moving"
            case .limited(.initializing):
                camStringStat = "initializing"
            case .limited(.insufficientFeatures):
                camStringStat = "need more features"
            case .limited(.relocalizing):
                camStringStat = "relocating"
            default:
                camStringStat = "?"
            }
        }
    }
}

struct ARDisplayView_Previews: PreviewProvider {
    static var previews: some View {
		ARDisplayView()
    }
}
