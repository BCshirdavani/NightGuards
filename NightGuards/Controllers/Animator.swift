//
//  Animator.swift
//  NightGuards
//
//  Created by shiMac on 1/2/21.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class Animator {
    
    let subject: Hero
    let node: SCNNode
    var animations = [String: CAAnimation]()
    var idle: Bool = true
    let resourceHelper: AnimationResourceHelper
    
    init(heroToAnimate: HeroImpl, sceneNode: SCNNode) {
        subject = heroToAnimate
        node = sceneNode
        resourceHelper = AnimationResourceHelper(name: heroToAnimate.heroName)
    }
    
    
    
    func loadAnimations () {
        // Load the character in the idle animation
        let idleScene = SCNScene(named: resourceHelper.getIdleNamePath())!
        
        let trumpNode = SCNNode()
        trumpNode.name = resourceHelper.getNodeName()
        
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            trumpNode.addChildNode(child)
        }
        
        // Set up some properties
        trumpNode.scale = SCNVector3(0.001, 0.001, 0.001)
        node.addChildNode(trumpNode)
        
        // Load all the DAE animations
        DispatchQueue.main.async {
            let animations = self.resourceHelper.getAnimations()
            animations.keys.forEach { (k) in
                if let resource = animations[k] {
                    self.loadAnimation(withKey: k, sceneName: resource["scene"]!, animationIdentifier: resource["id"]!, repCount: (resource["count"]! as NSString).floatValue)
                }
            }
        }
    }
    
    func addParentToChildNode(parentNode: SCNNode) {
        parentNode.addChildNode(node)
    }
    
    func anchorNodeToScene(sceneView: ARSCNView) {
        // Add the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func loadAnimation(withKey: String, sceneName: String, animationIdentifier: String, repCount: Float = 1) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = repCount
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
    
    func playAnimation(key: String, activeScnView: ARSCNView) {
        // Add the animation to start playing it right away
//        sceneView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
        activeScnView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
    }
    
    func stopAnimation(key: String, activeScnView: ARSCNView) {
        // Stop the animation with a smooth transition
//        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
        activeScnView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }
    
    
    
}


// MARK: Environment Object, for all animations
final class Animators: ObservableObject {
    // TOOD: consider removing @Published, as we are using this as shared data store, not as view component requiring a refresh
    static var animeDict: Dictionary<String, Animator> = Dictionary<String, Animator>()
//    var animeDict: Dictionary<String, Animator> = Dictionary<String, Animator>()
    
//    func updateAnimatorForHero(heroIn: HeroImpl, node: SCNNode) {
//        let animator = Animator(heroToAnimate: heroIn, sceneNode: node)
//        Animators.animeDict.updateValue(animator, forKey: heroIn.heroName)
//    }
}


struct AnimationResourceHelper {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getNodeName() -> String {
        switch name {
        case "trump":
            return "trumpNode_animator"
        case "lucha":
            return "luchaNode_animator"
        case "ninja":
            return "ninjaNode_animator"
        case "paladin":
            return "paladinNode_animator"
        default:
            return "otherNode_animator"
        }
    }
    
    func getIdleNamePath() -> String {
        switch name {
        case "trump":
            return "art.scnassets/TrumpAnimations/IdleFixed.dae"
        case "lucha":
            return "art.scnassets/Lucha/idleLucha.dae"
        case "ninja":
            return "art.scnassets/Ninja/idle.dae"
        case "paladin":
            return "art.scnassets/Paladin/idle.dae"
        default:
            return "no animation for selected hero"
        }
    }
    
    // TODO: add the remaining animations
    func getAnimations() -> [String: [String: String]] {
        var dict = [String: [String: String]]()
        switch name {
        case "trump":
            dict["crunch"] = ["id": "biCrunch-1",
                              "scene": "art.scnassets/TrumpAnimations/biCrunch",
                              "count": "8"]
            dict["jump"] = ["id": "jump-1",
                            "scene": "art.scnassets/TrumpAnimations/jump",
                            "count": "1"]
            dict["twerl"] = ["id": "Twerk-1",
                             "scene": "art.scnassets/TrumpAnimations/Twerk",
                             "count": "1"]
            return dict
        case "lucha":
            dict["slam"] = ["id": "GrabSlam-1",
                            "scene": "art.scnassets/Lucha/GrabSlam",
                            "count": "1"]
            dict["jog"] = ["id": "jog-1",
                           "scene": "art.scnassets/Lucha/jog",
                           "count": "1"]
            dict["jumpJack"] = ["id": "jumpJack-1",
                                "scene": "art.scnassets/Lucha/jumpJack",
                                "count": "8"]
            dict["pain"] = ["id": "Pain-1",
                            "scene": "art.scnassets/Lucha/Pain",
                            "count": "1"]
            dict["stomp"] = ["id": "stomping-1",
                             "scene": "art.scnassets/Lucha/stomping",
                             "count": "1"]
            return dict
        case "ninja":
            dict["crescentKick"] = ["id": "CrescentJumpKick-1",
                                    "scene": "art.scnassets/Ninja/CrescentJumpKick",
                                    "count": "1"]
            dict["hurricane"] = ["id": "hurricane-1",
                                 "scene": "art.scnassets/Ninja/hurricane",
                                 "count": "5"]
            dict["jump"] = ["id": "jump-1",
                            "scene": "art.scnassets/Ninja/jump",
                            "count": "1"]
            dict["kick"] = ["id": "kick-1",
                            "scene": "art.scnassets/Ninja/kick",
                            "count": "1"]
            dict["runFlip"] = ["id": "RunFlip-1",
                               "scene": "art.scnassets/Ninja/RunFlip",
                               "count": "1"]
            dict["runAway"] = ["id": "RunningAway-1",
                               "scene": "art.scnassets/Ninja/RunningAway",
                               "count": "1"]
            return dict
        case "paladin":
            dict["circle"] = ["id": "circle-1",
                              "scene": "art.scnassets/Paladin/circle",
                              "count": "1"]
            dict["impact"] = ["id": "impact-1",
                              "scene": "art.scnassets/Paladin/impact",
                              "count": "1"]
            dict["slash1"] = ["id": "slash_1-1",
                              "scene": "art.scnassets/Paladin/slash_1",
                              "count": "1"]
            dict["slash2"] = ["id": "slash_2-1",
                              "scene": "art.scnassets/Paladin/slash_2",
                              "count": "1"]
            return dict
        default:
            return dict
        }
    }
    
    
    
}
