//
//  HeroModel.swift
//  NightGuards
//
//  Created by shiMac on 12/12/20.
//

import Foundation
import ARKit
import RealityKit


// MARK: protocol interface
protocol Hero {
    var arAnchorContainer: AnchorContainer? { get set }
    var heroMapURLString: String? { get set }
    var heroName: String { get }
}

// MARK: implementation of Hero protocol
final class HeroImpl: Hero, Codable {
    var arAnchorContainer: AnchorContainer?
    
    var heroMapURLString: String?
        
    var heroUnlocked: Bool = true
    
    let heroName: String
    
    init(heroName: String) {
        self.heroName = heroName
    }
    
    func getHeroScnNode() -> SCNNode {
        let heroFactory: HeroFactory = HeroFactory()
        let modelNode: SCNNode = heroFactory.buildHeroModelNode(heroName: heroName)
        return modelNode
    }
    
    func modifyArAnchor(newAnchor: ARAnchor) {
        arAnchorContainer = AnchorContainer(anchor: newAnchor)
    }
    
    func isPlaced() -> Bool {
        if arAnchorContainer?.anchor != nil {
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

// MARK: ARAnchor wrapper
class AnchorContainer: Codable {
    let anchor: ARAnchor

    init(anchor: ARAnchor) {
        self.anchor = anchor
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let transform0 = try container.decode(simd_float4.self, forKey: .transform0)
        let transform1 = try container.decode(simd_float4.self, forKey: .transform1)
        let transform2 = try container.decode(simd_float4.self, forKey: .transform2)
        let transform3 = try container.decode(simd_float4.self, forKey: .transform3)
        let matrix = simd_float4x4(columns: (transform0, transform1, transform2, transform3))
        anchor = ARAnchor(name: name, transform: matrix)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(anchor.name, forKey: .name)
        try container.encode(anchor.transform.columns.0, forKey: .transform0)
        try container.encode(anchor.transform.columns.1, forKey: .transform1)
        try container.encode(anchor.transform.columns.2, forKey: .transform2)
        try container.encode(anchor.transform.columns.3, forKey: .transform3)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case transform0
        case transform1
        case transform2
        case transform3
    }
}

// MARK: aggregate singleton that holds all Heroes implemented
final class Heroes: Codable {
    public static var heroDict = [String : HeroImpl]()
    
    init() {
        Heroes.heroDict["ball"] = HeroImpl(heroName: "ball")
        Heroes.heroDict["cone"] = HeroImpl(heroName: "cone")
        Heroes.heroDict["kang"] = HeroImpl(heroName: "kang")
        Heroes.heroDict["robo"] = HeroImpl(heroName: "robo")
        load()
    }
    
    static func save() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(Heroes.heroDict), forKey:"heroDict")
    }
    
    func load() {
        if let data = UserDefaults.standard.value(forKey:"heroDict") as? Data {
            let loadedHeroDict = try? PropertyListDecoder().decode([String : HeroImpl].self, from: data)
            Heroes.heroDict = loadedHeroDict ?? Heroes.heroDict
        }
    }
    
    
}



