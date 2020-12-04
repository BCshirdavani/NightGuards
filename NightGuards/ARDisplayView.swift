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
    let arViewContainer: ARViewContainer = ARViewContainer()
    var body: some View {
        arViewContainer.gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onEnded { value in
                    self.placeBall(position: value.location)
                }
        )
        
    }
    
    func placeBall(position: CGPoint) {
        arViewContainer.castRaySimple(point: position)
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
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]

        if ARGeoTrackingConfiguration.isSupported {
            print(" * supports scene reconstruction")
            self.arView.debugOptions = [.showSceneUnderstanding, .showStatistics]
            configuration.sceneReconstruction = [.meshWithClassification]
            self.arView.environment.sceneUnderstanding.options.insert(.occlusion)
        } else {
            print(" * does NOT support scene reconstruction")
            self.arView.debugOptions = [.showWorldOrigin, .showAnchorOrigins, .showFeaturePoints]
        }
        self.arView.session.run(configuration, options: options)
    }
    
    func makeBallEntity() -> ModelEntity {
        let mesh = MeshResource.generateSphere(radius: 0.03)
        let color = UIColor.red
        let material = SimpleMaterial(color: color, isMetallic: false)
        let coloredSphere = ModelEntity(mesh: mesh, materials: [material])
        return coloredSphere
    }
    
    func makeBallAnchor() -> ARAnchor {
        let trans = simd_float4x4(0.0)
        let anchor = ARAnchor(transform: trans)
        let sphereNode = SCNNode()
        let sphereNodeGeometry = SCNSphere(radius: 0.01)
        sphereNodeGeometry.firstMaterial?.diffuse.contents = UIColor.cyan
        sphereNode.geometry = sphereNodeGeometry
        return anchor

    }
    
    func castRaySimple(point: CGPoint) {
        let tapLocation: CGPoint = point
        let estimatedPlane: ARRaycastQuery.Target = .estimatedPlane
        let alignment: ARRaycastQuery.TargetAlignment = .horizontal

        let result: [ARRaycastResult] = arView.raycast(from: tapLocation,
                                                       allowing: estimatedPlane,
                                                       alignment: alignment)
        guard let rayCast: ARRaycastResult = result.first
        else {
            print("....no rayCast result....")
            return
        }
        let anchor = AnchorEntity(world: rayCast.worldTransform)
        let model = makeBallEntity()
        anchor.addChild(model)
        arView.scene.anchors.append(anchor)
        arView.session.add(anchor: makeBallAnchor())
    }
    
}

struct ARDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ARDisplayView()
    }
}
