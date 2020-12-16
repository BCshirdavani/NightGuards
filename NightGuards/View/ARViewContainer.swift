//
//  ARViewContainer.swift
//  NightGuards
//
//  Created by shiMac on 12/13/20.
//

import SwiftUI
import UIKit
import ARKit
import RealityKit


final class ARViewContainer: NSObject, UIViewRepresentable, ARSessionDelegate {
    var arView: ARView
    let heroFactory = HeroFactory()
    let heroes: Heroes = Heroes()
    let session: ARSession
    let dataController: DataPersistController = DataPersistController()
    var worldMapURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("worldMapURL")
        } catch {
            fatalError("Error getting world map URL from document directory.")
        }
    }()
    
    override init() {
        arView = ARView(frame: .zero)
        session = ARSession()
    }
    
    func makeUIView(context: Context) -> ARView {
        configAR()
        arView.session.delegate = self
        return arView
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(" - tracking state change:\t\(camera.trackingState)")
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
