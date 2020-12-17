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

	init() {
		self.arViewContainer = ARViewContainer()
	}

    var body: some View {
		ZStack {
            arViewContainer.onTapGesture {
                setCamStatus()
                print(" - cam tracking state:\t\(camStringStat)")
            }.gesture(DragGesture(minimumDistance: 5.0, coordinateSpace: .local).onEnded({ (value) in
                print("width: \(value.translation.width), height: \(value.translation.height)")
                if value.translation.width < -100 {
                    print(" - swiped left")
                    roomIndex -= 1
                    switchRoom()
                    print(mapName)
                }
                else if value.translation.width > 100 {
                    print(" - swiped right")
                    roomIndex += 1
                    switchRoom()
                    print(mapName)
                }
                else if value.translation.height < -100 {
                    print(" - swiped up")
                    withAnimation{
                        showButtons = true
                    }
                }
                else if value.translation.height > 100 {
                    print(" - swiped down")
                    withAnimation{
                        showButtons = false
                    }
                }
            }))
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
                                self.placeHero(position: arViewContainer.arView.center, object: heroSelected)
                                self.dataController.stageHeroUpdates(name: heroSelected, map: mapName, unlocked: true)
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
        arViewContainer.castRaySimple(point: position, object: object)
        if let hero = Heroes.heroDict[object] {
            anchorPlaced = hero.isPlaced()
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
        if let trackState = arViewContainer.arView.session.currentFrame?.camera.trackingState {
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
