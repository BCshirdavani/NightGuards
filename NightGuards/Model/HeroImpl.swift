//
//  HeroModel.swift
//  NightGuards
//
//  Created by shiMac on 12/12/20.
//

import Foundation
import ARKit
import RealityKit

protocol Hero {
    var anchorEntity: AnchorEntity? { get set }
    var arAnchor: ARAnchor? { get set }
    var model: Entity { get }
    var modelNode: SCNNode { get set }
    var heroFactory: HeroFactory { get }
    var heroMapURLString: String? { get set }
}

final class HeroImpl: Hero {
    var modelNode: SCNNode
    
    var arAnchor: ARAnchor?
    
    var heroFactory: HeroFactory = HeroFactory()
    
    var anchorEntity: AnchorEntity?
    
    var model: Entity
    
    var heroMapURLString: String?
    
    let heroID: UUID
    
    let heroUnlocked: Bool = true
    
    let heroName: String
    
    init(heroName: String) {
        model = heroFactory.buildHeroModel(heroName: heroName)
        modelNode = heroFactory.buildHeroModelNode(heroName: heroName)
        heroID = heroFactory.makeHeroID(heroName: heroName)
        self.heroName = heroName
    }
    
    func modifyAnchorEntity(newAnchor: AnchorEntity) {
        anchorEntity = newAnchor
    }
    func modifyArAnchor(newAnchor: ARAnchor) {
        arAnchor = newAnchor
    }
    
    func removeAnchor() {
        anchorEntity = nil
    }
    
    func isPlaced() -> Bool {
        if anchorEntity != nil {
            return true
        } else {
            return false
        }
    }
    
    func setHeroMap(mapName: String) {
        heroMapURLString = mapName
    }
    
    func deleteMap() {
        heroMapURLString = nil
    }
}

final class Heroes {
    public static var heroDict = [String : HeroImpl]()
    
    init() {
        Heroes.heroDict["ball"] = HeroImpl(heroName: "ball")
        Heroes.heroDict["cone"] = HeroImpl(heroName: "cone")
        Heroes.heroDict["kang"] = HeroImpl(heroName: "kang")
        Heroes.heroDict["robo"] = HeroImpl(heroName: "robo")
    }
}



