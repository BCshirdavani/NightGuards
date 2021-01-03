//
//  HeroFactory.swift
//  NightGuards
//
//  Created by shiMac on 12/12/20.
//

import Foundation
import ARKit
import RealityKit

struct HeroFactory {
    
    func buildHeroModelNode(heroName: String) -> SCNNode {
        switch heroName {
        case "ball":
            let ball = makeBallNode()
            return ball
        case "cone":
            let cone = makeConeNode()
            return cone
        case "trump":
            let tump = getTrumpNodes()
            return tump
        default:
            let box = makeBoxNode()
            return box
        }
    }
    
    func getTrumpNodes() -> SCNNode {
        let node = SCNNode()
        node.name = "trump"
//        let scene = SCNScene(named: "art.scnassets/TrumpAnimations/IdleFixed.dae")
//        let nodeArray = scene!.rootNode.childNodes
//        for childNode in nodeArray {
//          node.addChildNode(childNode as SCNNode)
//        }
        return node
    }
    
    func makeBallNode() -> SCNNode {
        let sphere = SCNSphere(radius: 0.1)
        sphere.materials.first?.diffuse.contents = UIColor.red
        let sphereNode = SCNNode()
        sphereNode.position.y += Float(sphere.radius)
        sphereNode.geometry = sphere
        sphereNode.castsShadow = true
        return sphereNode
    }
    
    func makeConeNode() -> SCNNode {
        let cone = SCNCone(topRadius: 0.001, bottomRadius: 0.1, height: 0.2)
        cone.materials.first?.diffuse.contents = UIColor.blue
        let coneNode = SCNNode()
        coneNode.position.y += Float(cone.bottomRadius)
        coneNode.geometry = cone
        return coneNode
    }
    
    func makeBoxNode() -> SCNNode {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.materials.first?.diffuse.contents = UIColor.green
        let boxNode = SCNNode()
        boxNode.position.y += Float(box.length)
        boxNode.geometry = box
        return boxNode
    }
    
    func makeHeroID(heroName: String) -> UUID {
        let defaultID: UUID = UUID()
        switch heroName {
        case "ball":
            let idString = "BALLE1F8-C36C-495A-93FC-0C247A3E6E5F"
            let uuid = UUID(uuidString: idString) ?? defaultID
            return uuid
        case "cone":
            let idString = "CONEE1F8-C36C-495A-93FC-0C247A3E6E5F"
            let uuid = UUID(uuidString: idString) ?? defaultID
            return uuid
        case "trump":
            let idString = "TRUMP1F8-C36C-495A-93FC-0C247A3E6E5F"
            let uuid = UUID(uuidString: idString) ?? defaultID
            return uuid
        default:
            let idString = "KANGE1F8-C36C-495A-93FC-0C247A3E6E5F"
            let uuid = UUID(uuidString: idString) ?? defaultID
            return uuid
        }
    }
    
}
