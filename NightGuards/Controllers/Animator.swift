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

struct Animator {
    
    let subject: Hero
    let node: SCNNode
    let sceneView: ARSCNView
    var animations = [String: CAAnimation]()
    var idle: Bool = true
    
    init(heroToAnimate: HeroImpl, sceneNode: SCNNode, arSceneView: ARSCNView) {
        subject = heroToAnimate
        node = sceneNode
        sceneView = arSceneView
        loadAnimations()
    }
    
    
    
    mutating func loadAnimations () {
        // Load the character in the idle animation
        let idleScene = SCNScene(named: "art.scnassets/TrumpAnimations/IdleFixed.dae")!
        
        let trumpNode = SCNNode()
        
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            trumpNode.addChildNode(child)
        }
        
        // Set up some properties
//        node.position = SCNVector3(0, 0, 0)
        trumpNode.scale = SCNVector3(0.001, 0.001, 0.001)
        node.addChildNode(trumpNode)
        
        // Add the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
        
        // Load all the DAE animations
        loadAnimation(withKey: "crunch", sceneName: "art.scnassets/TrumpAnimations/biCrunch", animationIdentifier: "biCrunch-1")
        loadAnimation(withKey: "jump", sceneName: "art.scnassets/TrumpAnimations/jump", animationIdentifier: "jump-1")
    }
    
    mutating func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = 1
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
    
    func playAnimation(key: String) {
        // Add the animation to start playing it right away
        sceneView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
    }
    
    func stopAnimation(key: String) {
        // Stop the animation with a smooth transition
        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }
    
    
    
}
