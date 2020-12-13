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
    let heroes: Heroes = Heroes()

	init() {
		self.arViewContainer = ARViewContainer()
	}

    var body: some View {
		ZStack {
			arViewContainer
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
                    NavigationLink(destination: HeroUIView(heroSelected: $heroSelected, anchorPlaced: $anchorPlaced)) {
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
}



struct ARViewContainer: UIViewRepresentable {
        
    var arView: ARView
    
    let heroFactory = HeroFactory()
    
    let heroes: Heroes = Heroes()
    
    var worldMapURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("worldMapURL")
        } catch {
            fatalError("Error getting world map URL from document directory.")
        }
    }()
    
    init() {
        arView = ARView(frame: .zero)
    }
    
    func makeUIView(context: Context) -> ARView {
        
        configAR()
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func configAR() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.worldAlignment = .gravityAndHeading
        configuration.environmentTexturing = .automatic
		let options: ARSession.RunOptions = [.stopTrackedRaycasts, .resetTracking, .removeExistingAnchors]

        if ARGeoTrackingConfiguration.isSupported {
            print(" * supports scene reconstruction")
            self.arView.debugOptions = [.showSceneUnderstanding/*, .showAnchorOrigins*/]
            configuration.sceneReconstruction = [.meshWithClassification]
            self.arView.environment.sceneUnderstanding.options.insert(.occlusion)
        } else {
            print(" * does NOT support scene reconstruction")
            self.arView.debugOptions = [.showWorldOrigin, .showAnchorOrigins, .showFeaturePoints]
        }
        self.arView.session.run(configuration, options: options)
    }
    
    func makeBallEntity() -> ModelEntity {
		// this ball has no physics, and adds successive balls properly, without
		// fucking with old anchors
        print(" - makeBallEntity()")
        let mesh = MeshResource.generateSphere(radius: 0.03)
        let color = UIColor.red
        let material = SimpleMaterial(color: color, isMetallic: false)
        let coloredSphere = ModelEntity(mesh: mesh, materials: [material])
        return coloredSphere
    }
    
    func makeConeModel() -> Entity {
		// TODO: the cone scene has physics, and erroneously updates old anchor planes
		// when adding new anchor model
        let entity = try! Entity.load(named: "Cone2")
        return entity
    }
    
    func castRaySimple(point: CGPoint, object: String) {
        print(" - castRaySimple()")
        let tapLocation: CGPoint = point
		let estimatedPlane: ARRaycastQuery.Target = .existingPlaneGeometry
        let alignment: ARRaycastQuery.TargetAlignment = .any

        let result: [ARRaycastResult] = arView.raycast(from: tapLocation,
                                                       allowing: estimatedPlane,
													   alignment: alignment)
        guard let rayCast: ARRaycastResult = result.first
        else {
            print("....no rayCast result....")
            return
        }
        let anchor = AnchorEntity(world: rayCast.worldTransform)
        
        if let model = Heroes.heroDict[object]?.model {
            Heroes.heroDict[object]?.modifyAnchor(newAnchor: anchor)
            anchor.addChild(model)
            arView.scene.addAnchor(anchor)
        }
    }
    
}

struct ARDisplayView_Previews: PreviewProvider {
    static var previews: some View {
		ARDisplayView()
    }
}
