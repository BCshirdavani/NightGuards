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
    var anchorEntity: AnchorEntity? { get }
    var model: Entity { get }
    var heroFactory: HeroFactory { get }
    var heroMapURLString: String? { get set }
}

final class HeroImpl: Hero {
    var heroFactory: HeroFactory = HeroFactory()
    
    var anchorEntity: AnchorEntity?
    
    var model: Entity
    
    var heroMapURLString: String?
    
    let heroID: UUID
    
    let heroUnlocked: Bool = true
    
    let heroName: String
    
    init(heroName: String) {
        model = heroFactory.buildHeroModel(heroName: heroName)
        heroID = heroFactory.makeHeroID(heroName: heroName)
        self.heroName = heroName
    }
    
    func modifyAnchor(newAnchor: AnchorEntity) {
        anchorEntity = newAnchor
    }
    
    func removeAnchor() {
        anchorEntity = nil
    }
    
    func isPlaced() -> Bool {
        print(" - anchorEntity...")
        if anchorEntity != nil {
            print(anchorEntity.debugDescription)
            return true
        } else {
            print(anchorEntity.debugDescription)
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
    }
}



