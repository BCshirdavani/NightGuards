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
        case K.TRUMP:
            let trump = getTrumpNodes()
            return trump
        case K.LUCHA:
            let lucha = getLuchaNodes()
            return lucha
        case K.DONUT:
            let donut = getDonutNode()
            return donut
        case K.PALADIN:
            let paladin = getPaladinNodes()
            return paladin
        case K.NINJA:
            let ninja = getNinjaNodes()
            return ninja
        default:
            let donut = getDonutNode()
            return donut
        }
    }
    
    func getTrumpNodes() -> SCNNode {
        let node = SCNNode()
        node.name = "\(K.TRUMP)Node_fromFactoryGetter"
        if let trumpNodeFromSingleton = Animators.animeDict[K.TRUMP]?.node {
            node.addChildNode(trumpNodeFromSingleton)
        }
        return node
    }
    
    func getPaladinNodes() -> SCNNode {
        let node = SCNNode()
        node.name = "\(K.PALADIN)Node_fromFactoryGetter"
        if let paladinNodeFromSingleton = Animators.animeDict[K.PALADIN]?.node {
            node.addChildNode(paladinNodeFromSingleton)
        }
        return node
    }
    
    func getNinjaNodes() -> SCNNode {
        let node = SCNNode()
        node.name = "\(K.NINJA)Node_fromFactoryGetter"
        if let ninjaNodeFromSingleton = Animators.animeDict[K.NINJA]?.node {
            node.addChildNode(ninjaNodeFromSingleton)
        }
        return node
    }
    
    func getLuchaNodes()-> SCNNode {
        let node = SCNNode()
        node.name = "\(K.LUCHA)Node_fromFactoryGetter"
        if let luchaNodeFromSingleton = Animators.animeDict[K.LUCHA]?.node {
            node.addChildNode(luchaNodeFromSingleton)
        }
        return node
    }
    
    func getDonutNode() -> SCNNode {
        let node = SCNNode()
        node.name = K.DONUT
        let scene = SCNScene(named: "art.scnassets/Donut/donutDelta01.dae")
        let nodeArray = scene!.rootNode.childNodes
        for childNode in nodeArray {
            node.addChildNode(childNode as SCNNode)
        }
        node.scale = SCNVector3(0.1, 0.1, 0.1)
        node.simdScale = SIMD3(SCNVector3(0.1, 0.1, 0.1))
        return node
    }
    
}
