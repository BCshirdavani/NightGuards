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
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("worldMapURL")
        } catch {
            print("failed to initialize worldMapURL")
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
        loadMap()
        return arView
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(" - tracking state change:\t\(camera.trackingState)")
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func configAR(with worldMap: ARWorldMap? = nil) {
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
        if let worldMap = worldMap {
            configuration.initialWorldMap = worldMap
        } else {
            print(" --- Move camera around to map your surrounding space.")
        }
        
        if worldMap?.anchors.count ?? 0 > 1 {
            for anchor in worldMap!.anchors {
                if anchor.name != nil {
                    addModelToExistingAnchor(anchor: anchor)
                }
            }
        }
        self.arView.session.run(configuration, options: options)
    }
    
    func castRaySimple(point: CGPoint, object: String) {
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
        let arAnchor = ARAnchor(name: object, transform: rayCast.worldTransform)
        let anchorEntity = AnchorEntity(anchor: arAnchor)
        if let model = Heroes.heroDict[object]?.model {
            Heroes.heroDict[object]?.modifyAnchorEntity(newAnchor: anchorEntity)
            Heroes.heroDict[object]?.modifyArAnchor(newAnchor: arAnchor)
            anchorEntity.addChild(model)
            arView.scene.addAnchor(anchorEntity)
            arView.session.getCurrentWorldMap { (map, error) in
                if map != nil {
                    // filter out duplicate anchors
                    let filteredMapAnchors = map?.anchors.filter({ (anchor) -> Bool in
                        // TODO: confirm arView.session anchors do not accululate into memory leak
//                        self.arView.session.remove(anchor: anchor)
                        return anchor.name != object
                    })
                    map?.anchors = filteredMapAnchors ?? []
                }
            }
            arView.session.add(anchor: arAnchor)
        }
        saveMap()
    }
    
    func killAllARAnchors() {
        arView.session.getCurrentWorldMap { (map, error) in
            if map != nil {
                let filteredMapAnchors = map?.anchors.filter({ (anchor) -> Bool in
                        self.arView.session.remove(anchor: anchor)
                    return !anchor.isMember(of: ARAnchor.self)
                })
                map?.anchors = filteredMapAnchors ?? []
            }
        }
        saveMap()
    }
    
    // MARK: map persistence
    func archive(worldMap: ARWorldMap) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: self.worldMapURL, options: [.atomic])
    }
    
   func saveMap() {
        arView.session.getCurrentWorldMap { (worldMap, error) in
            guard let worldMap = worldMap else {
                print("Error getting current world map.")
                return
            }
            do {
                try self.archive(worldMap: worldMap)
            } catch {
                fatalError("Error saving world map: \(error.localizedDescription)")
            }
        }
    }

    func retrieveWorldMapData(from url: URL) -> Data? {
        do {
            try print(Data(contentsOf: self.worldMapURL).description)
            return try Data(contentsOf: self.worldMapURL)
        } catch {
            print("Error retrieving world map data.")
            return nil
        }
    }

    func unarchive(worldMapData data: Data) -> ARWorldMap? {
        guard let unarchievedObject = ((try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)) as ARWorldMap??),
              let worldMap = unarchievedObject else { return nil }
        return worldMap
    }
    
    func loadMap() {
        guard let worldMapData = retrieveWorldMapData(from: worldMapURL),
              let worldMap = unarchive(worldMapData: worldMapData) else { return }
        print(worldMap)
        configAR(with: worldMap)
    }
    
    func addModelToExistingAnchor(anchor: ARAnchor) {
        let anchorEntity = AnchorEntity(anchor: anchor)
        if let model = Heroes.heroDict[anchor.name!]?.model{
            anchorEntity.addChild(model)
            arView.scene.addAnchor(anchorEntity)
        }
    }
        
}
