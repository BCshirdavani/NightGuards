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
    
    func buildHeroModel(heroName: String) -> Entity {
        switch heroName {
        case "ball":
            let ball = makeBallEntity()
            return ball
        case "cone":
            let cone = makeConeModel()
            return cone
        default:
            let box = makeBoxEntity()
            return box
        }
    }
    
    func makeBallEntity() -> ModelEntity {
        // this ball has no physics, and adds successive balls properly, without
        // fucking with old anchors
        print(" - makeBallEntity()")
        let mesh = MeshResource.generateSphere(radius: 0.03)
        let color = UIColor.red
        let material = SimpleMaterial(color: color, isMetallic: false)
        let coloredSphere = ModelEntity(mesh: mesh, materials: [material])
        return coloredSphere
    }
    
    func makeBoxEntity() -> ModelEntity {
        // this ball has no physics, and adds successive balls properly, without
        // fucking with old anchors
        print(" - makeBallEntity()")
        let mesh = MeshResource.generateBox(size: 0.03)
        let color = UIColor.blue
        let material = SimpleMaterial(color: color, isMetallic: false)
        let coloredSphere = ModelEntity(mesh: mesh, materials: [material])
        return coloredSphere
    }
    
    
    func makeConeModel() -> Entity {
        // TODO: the cone scene has physics, and erroneously updates old anchor planes
        // when adding new anchor model
        let entity = try! Entity.load(named: "Cone2")
        return entity
    }
    
}
