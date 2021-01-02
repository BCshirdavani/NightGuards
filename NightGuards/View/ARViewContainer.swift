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

final class ARViewContainer: NSObject, ARSessionDelegate, ARSCNViewDelegate, UIViewRepresentable {
    
    typealias UIViewType = ARSCNView

    var arScnView: ARSCNView
    let heroFactory = HeroFactory()
    let heroes: Heroes = Heroes()
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
    var currentMapCopy: ARWorldMap?
    
    override init() {
        arScnView = ARSCNView(frame: .zero)
        arScnView.autoenablesDefaultLighting = true
        arScnView.rendersMotionBlur = true
        arScnView.automaticallyUpdatesLighting = true
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        configAR()
        arScnView.session.delegate = self
        arScnView.delegate = self
        loadMap()
        return arScnView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: UIViewRepresentableContext<ARViewContainer>) {}
    
    func configAR(with worldMap: ARWorldMap? = nil) {
        let configuration = self.setupARConfig(with: worldMap)
        let options: ARSession.RunOptions = [.stopTrackedRaycasts, .resetTracking, .removeExistingAnchors]
        self.arScnView.debugOptions = [.showWorldOrigin, .showFeaturePoints, /*.renderAsWireframe*/]
        self.arScnView.session.run(configuration, options: options)
    }
    
    func setupARConfig(with worldMap: ARWorldMap? = nil) -> ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.worldAlignment = .gravityAndHeading
        config.environmentTexturing = .automatic
        if ARGeoTrackingConfiguration.isSupported {
            print(" * geo tracking supported")
        } else {
            print(" * geo tracking NOT supported")
        }
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            print(" * scene reconstruction supported")
        } else {
            print(" * scene reconstruction NOT supported")
        }
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            print(" * scene depth supported")
        } else {
            print(" * scene depth NOT supported")
        }
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            print(" * person segmentation w/ depth supported")
        } else {
            print(" * person segmentation w/ depth NOT supported")
        }
        if let worldMap = worldMap {
            config.initialWorldMap = worldMap
        } else {
            print(" --- Move camera around to map your surrounding space.")
        }
        return config
    }
    
    
    
    func castRaySimple(point: CGPoint, object: String) {
        let tapLocation: CGPoint = point
        let estimatedPlane: ARRaycastQuery.Target = .existingPlaneGeometry
        let alignment: ARRaycastQuery.TargetAlignment = .any
        
        let rayCastQuery = arScnView.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: alignment)
        var result: [ARRaycastResult]
        if rayCastQuery != nil {
            result = arScnView.session.raycast(rayCastQuery!)
            guard let rayCast: ARRaycastResult = result.first
            else {
                print("....no rayCast result....")
                return
            }
            // remove old anchor
            if let oldAnchor = Heroes.heroDict[object]?.arAnchorContainer?.anchor {
                arScnView.session.remove(anchor: oldAnchor)
            }
            // add new anchor
            let arAnchor = ARAnchor(name: object, transform: rayCast.worldTransform)
            Heroes.heroDict[object]?.modifyArAnchor(newAnchor: arAnchor)
            arScnView.session.add(anchor: arAnchor)
            arScnView.session.getCurrentWorldMap { (map, error) in
                if map != nil {
                    map?.anchors.filter({ (mapAnchor) -> Bool in
                        return mapAnchor.name != object
                    })
                    map?.anchors.append(arAnchor)
                }
            }
            //            saveMap()
        }
    }
    
    
    
    
    
    // MARK: ARSessionDelegate methods
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(" - cam tracking state change:\t\(camera.trackingState)")
    }
    
    func session(_ session: ARSession, didChange geoTrackingStatus: ARGeoTrackingStatus) {
        print(" - geo tracking status change:\t\(geoTrackingStatus)")
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        let anchorName = anchors.first?.name
        print(" - added anchor with name: \(anchorName)")
    }
    
    // MARK: ARSCNViewDelegate method
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let chosenHero: HeroImpl = Heroes.heroDict[anchor.name ?? ""] {
            node.addChildNode(chosenHero.getHeroScnNode())
        }
    }
    
    

    func killAllARAnchors() {
        arScnView.session.getCurrentWorldMap { (map, error) in
            if map != nil {
                let filteredMapAnchors = map?.anchors.filter({ (anchor) -> Bool in
                        self.arScnView.session.remove(anchor: anchor)
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
    arScnView.session.getCurrentWorldMap { (worldMap, error) in
            guard let worldMap = worldMap else {
                print("Error getting current world map.")
                return
            }
            do {
                self.currentMapCopy = worldMap
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
        currentMapCopy = worldMap
        configAR(with: worldMap)
    }
        
}


