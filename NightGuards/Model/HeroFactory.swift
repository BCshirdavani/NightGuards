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
        case "robo":
            let cone = makeRoboModel()
            return cone
        default:
            let box = makeBoxEntity()
            return box
        }
    }
    
    func buildHeroModelNode(heroName: String) -> SCNNode {
        switch heroName {
        case "ball":
            let ball = makeBallNode()
            return ball
        case "cone":
            let cone = makeConeNode()
            return cone
        default:
            let box = makeBoxNode()
            return box
        }
    }
    
    func makeBallEntity() -> ModelEntity {
        // this ball has no physics, and adds successive balls properly, without
        // fucking with old anchors
        let mesh = MeshResource.generateSphere(radius: 0.03)
        let color = UIColor.red
        let material = SimpleMaterial(color: color, isMetallic: false)
        let coloredSphere = ModelEntity(mesh: mesh, materials: [material])
        return coloredSphere
    }
    
    func makeBoxEntity() -> ModelEntity {
        // this ball has no physics, and adds successive balls properly, without
        // fucking with old anchors
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
    
    func makeRoboModel() -> Entity {
        let entity = try! Entity.load(named: "Robot")
        return entity
    }
    
    func makeBallNode() -> SCNNode {
        let sphere = SCNSphere(radius: 0.1)
        let sphereNode = SCNNode()
        sphereNode.position.y += Float(sphere.radius)
        sphereNode.geometry = sphere
        return sphereNode
    }
    
    func makeConeNode() -> SCNNode {
        let cone = SCNCone(topRadius: 0.001, bottomRadius: 0.1, height: 0.2)
        let coneNode = SCNNode()
        coneNode.position.y += Float(cone.bottomRadius)
        coneNode.geometry = cone
        return coneNode
    }
    
    func makeBoxNode() -> SCNNode {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
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
        default:
            let idString = "KANGE1F8-C36C-495A-93FC-0C247A3E6E5F"
            let uuid = UUID(uuidString: idString) ?? defaultID
            return uuid
        }
    }
    
}
