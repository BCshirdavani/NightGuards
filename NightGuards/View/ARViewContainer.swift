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
    var worldMapURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("worldMapURL")
        } catch {
            print("failed to initialize worldMapURL")
            fatalError("Error getting world map URL from document directory.")
        }
    }()
    let coachingOverlay: ARCoachingOverlayView = ARCoachingOverlayView()
    
    override init() {
        arScnView = ARSCNView(frame: .zero)
        arScnView.autoenablesDefaultLighting = true
//        arScnView.rendersMotionBlur = true
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        configAR()
        arScnView.session.delegate = self
        arScnView.delegate = self
        loadMap()
        setupCoachingOverlay()
        // TODO: rather than anchor "all" animations to scene, do this one at a time, as needed when model is placed
        if !Animators.animeDict.isEmpty {
            Animators.animeDict.values.forEach { (animator) in
                animator.anchorNodeToScene(sceneView: arScnView)
            }
        }
        return arScnView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: UIViewRepresentableContext<ARViewContainer>) {}
    
    func configAR(with worldMap: ARWorldMap? = nil) {
        let configuration = self.setupARConfig(with: worldMap)
        let options: ARSession.RunOptions = [.stopTrackedRaycasts, .resetTracking, .removeExistingAnchors]
//        self.arScnView.debugOptions = [.showWorldOrigin, .showFeaturePoints, .showBoundingBoxes]
        self.arScnView.session.run(configuration, options: options)
    }
    
    func setupARConfig(with worldMap: ARWorldMap? = nil) -> ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
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
        }
    }
    
    func detectObjectTap(point: CGPoint) {
        let hits = self.arScnView.hitTest(point, options: nil)
        if let tappedNode : SCNNode = hits.first?.node {
            print(" ~ tappedNode name: \(tappedNode.name)")
            print(" ~ tappedNode parent name: \(tappedNode.parent?.name)")
            // TODO: add conditions for other objects tapped
            if tappedNode.name?.contains("trump") ?? false || tappedNode.parent?.name?.contains("trump") ?? false {
                if let trumpAnimations = Animators.animeDict["trump"] {
                    if let randomAnimePick = trumpAnimations.animations.keys.randomElement() {
                        trumpAnimations.playAnimation(key: randomAnimePick, activeScnView: arScnView)
                    }
                }
            } else if tappedNode.name?.contains("lucha") ?? false || tappedNode.parent?.name?.contains("lucha") ?? false {
                if let luchaAnimations = Animators.animeDict["lucha"] {
                    if let randomAnimePick = luchaAnimations.animations.keys.randomElement() {
                        luchaAnimations.playAnimation(key: randomAnimePick, activeScnView: arScnView)
                    }
                }
            }
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
//        let anchorName = anchors.first?.name
    }
    
    // MARK: ARSCNViewDelegate method
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let chosenHero: HeroImpl = Heroes.heroDict[anchor.name ?? ""] {
            print(" - - - - - render node: \(node.name) for anchor: \(anchor.name)")
            self.arScnView.scene.rootNode.childNodes.forEach { (thisNode) in
                if thisNode.name == anchor.name {
                    thisNode.removeFromParentNode()
                }
            }
            if anchor.name == "trump" {
                // attach proper parent node for trump animations
                // TODO: this is ugly, and redundant - see HeroUI selection, we build trump animator there too
                if let trumpAnimator = Animators.animeDict["trump"] {
                    // case where current session, user chooses and places this object
                    trumpAnimator.addParentToChildNode(parentNode: node)
                } else {
                    // case where we enter and expect to see persisted object
                    let trumpNode = SCNNode()
                    trumpNode.name = "trumpNode_arscnView"
                    let trumpAnimator = Animator(heroToAnimate: Heroes.heroDict[anchor.name!]!, sceneNode: trumpNode)
                    Animators.animeDict.updateValue(trumpAnimator, forKey: anchor.name!)
                    if let trumpAnimator = Animators.animeDict["trump"] {
                        trumpAnimator.loadAnimations()
                    }
                    trumpAnimator.addParentToChildNode(parentNode: node)
                }
            } else if anchor.name == "lucha" {
                if let luchaAnimator = Animators.animeDict["lucha"] {
                    // case where current session, user chooses and places this object
                    luchaAnimator.addParentToChildNode(parentNode: node)
                } else {
                    // case where we enter and expect to see persisted object
                    let luchaNode = SCNNode()
                    luchaNode.name = "luchaNode_arscnView"
                    let luchaAnimator = Animator(heroToAnimate: Heroes.heroDict[anchor.name!]!, sceneNode: luchaNode)
                    Animators.animeDict.updateValue(luchaAnimator, forKey: anchor.name!)
                    if let luchaAnimator = Animators.animeDict["lucha"] {
                        luchaAnimator.loadAnimations()
                    }
                    luchaAnimator.addParentToChildNode(parentNode: node)
                }
            }
            else {
                // ball, square, cone
                node.name = anchor.name
                node.addChildNode(chosenHero.getHeroScnNode())
            }
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
        Heroes.heroDict.values.forEach { (hero) in
            hero.heroMapURLString = nil
            if let oldANchor = hero.arAnchorContainer?.anchor {
                arScnView.session.remove(anchor: oldANchor)
            }
            if let oldAnchorNode = arScnView.anchor(for: hero.getHeroScnNode()) {
                arScnView.session.remove(anchor: oldAnchorNode)
            }
            hero.arAnchorContainer = nil
        }
        let trumpNode = arScnView.scene.rootNode.childNode(withName: "trumpNode_heroUI", recursively: true)
        trumpNode?.removeFromParentNode()
        saveMap()
    }
    
    // MARK: map persistence
    func archive(worldMap: ARWorldMap) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: self.worldMapURL, options: [.atomic])
    }
    
    func saveMap() {
        DispatchQueue.main.async {
            self.arScnView.session.getCurrentWorldMap { (worldMap, error) in
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
        
}



/// - Tag: CoachingOverlayViewDelegate
extension ARViewContainer: ARCoachingOverlayViewDelegate {
    
    /// - Tag: HideUI
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print(" ~ coaching view will activate")
    }
    
    /// - Tag: PresentUI
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print(" ~ coaching view will activate")
//        upperControlsView.isHidden = false
    }

    /// - Tag: StartOver
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        print(" ~ coaching view will activate")
        self.killAllARAnchors()
        self.configAR()
    }

    func setupCoachingOverlay() {
        // Set up coaching view
        coachingOverlay.session = arScnView.session
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arScnView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: arScnView.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: arScnView.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: arScnView.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: arScnView.heightAnchor)
            ])
        
        setActivatesAutomatically()
        
        // Most of the virtual objects in this sample require a horizontal surface,
        // therefore coach the user to find a horizontal plane.
        setGoal()
    }
    
    /// - Tag: CoachingActivatesAutomatically
    func setActivatesAutomatically() {
//        coachingOverlay.activatesAutomatically = true
        print(" ~ coaching overlay active?: \(coachingOverlay.isActive)")
        coachingOverlay.setActive(true, animated: true)
        print(" ~ coaching overlay active?: \(coachingOverlay.isActive)")
    }

    /// - Tag: CoachingGoal
    func setGoal() {
        coachingOverlay.goal = .horizontalPlane
    }
}
