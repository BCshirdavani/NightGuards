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
    let heroes: Heroes = Heroes()

	init() {
		self.arViewContainer = ARViewContainer()
	}

    var body: some View {
		ZStack {
            arViewContainer.onTapGesture {
                setCamStatus()
                print(" - cam tracking state:\t\(camStringStat)")
            }
			VStack {
				Spacer()
				HStack {
					ZStack {
						Circle()
							.frame(width: 60, height: 60, alignment: .center)
							.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
							.foregroundColor(.black)
                            .onTapGesture {
                                self.placeHero(position: arViewContainer.arView.center, object: heroSelected)
                            }
						Text(buttonText()).foregroundColor(.white)
					}
					Spacer()
                    NavigationLink(destination: HeroUIView(heroSelected: $heroSelected, anchorPlaced: $anchorPlaced, heroes: heroes)) {
						ZStack {
							Circle()
								.frame(width: 60, height: 60, alignment: .center)
								.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
								.foregroundColor(.black)
							Text(heroSelected).foregroundColor(.white)
						}
					}
				}
			}
		}
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
