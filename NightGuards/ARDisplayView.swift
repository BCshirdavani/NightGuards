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

	init() {
		self.arViewContainer = ARViewContainer()
	}

    var body: some View {
		ZStack {
			arViewContainer.gesture(
				DragGesture(minimumDistance: 0, coordinateSpace: .global)
					.onEnded { value in
						self.placeBall(position: value.location)
					}
			)
			VStack {
				Spacer()
				HStack {
					ZStack {
						Circle()
							.frame(width: 60, height: 60, alignment: .center)
							.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
							.foregroundColor(.black)
						Text(buttonText()).foregroundColor(.white)
					}
					Spacer()
					NavigationLink(destination: HeroUIView()) {
						ZStack {
							Circle()
								.frame(width: 60, height: 60, alignment: .center)
								.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
								.foregroundColor(.black)
							Text("Hero").foregroundColor(.white)
						}
					}
				}
			}
		}

    }
    
    func placeBall(position: CGPoint) {
		arViewContainer.castRaySimple(point: position)
		DispatchQueue.main.async {
			toggleAnchorStatus()
		}
    }

	func toggleAnchorStatus() {
		let oldStatus = anchorPlaced
		let newStatus = !oldStatus
		anchorPlaced = newStatus
	}

	func buttonText() -> String {
		return anchorPlaced ? "place?" : "move?"
	}
}



struct ARViewContainer: UIViewRepresentable {
    
    var arView: ARView
    
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
    
    func castRaySimple(point: CGPoint) {
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
//		let entity = makeConeModel()
		let ball = makeBallEntity()
        anchor.addChild(ball)
        arView.scene.addAnchor(anchor)
    }
    
}

struct ARDisplayView_Previews: PreviewProvider {
    static var previews: some View {
		ARDisplayView()
    }
}
