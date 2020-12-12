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
    
    init(heroName: String) {
        model = heroFactory.buildHeroModel(heroName: heroName)
    }
    
    func modifyAnchor(newAnchor: AnchorEntity) {
        anchorEntity = newAnchor
    }
    
    func removeAnchor() {
        anchorEntity = nil
    }
    
}



