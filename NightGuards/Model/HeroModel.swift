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
    
}

class HeroModel: Hero {
    var heroFactory: HeroFactory = HeroFactory()
    
    var anchorEntity: AnchorEntity?
    
    var model: Entity
    
    var heroMapURLString: String?
    
    init(heroName: String) {
        model = heroFactory.buildHeroModel(heroName: heroName)
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

class Heroes {
    public static var heroDict = [String : HeroModel]()
    
    init() {
        Heroes.heroDict["ball"] = HeroModel(heroName: "ball")
        Heroes.heroDict["cone"] = HeroModel(heroName: "cone")
        Heroes.heroDict["kang"] = HeroModel(heroName: "kang")
    }
}



