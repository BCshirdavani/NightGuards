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
//    let sceneView: ARSCNView
    var animations = [String: CAAnimation]()
    var idle: Bool = true
    
    init(heroToAnimate: HeroImpl, sceneNode: SCNNode) {
        subject = heroToAnimate
        node = sceneNode
//        loadAnimations()
    }
    
    
    
    func loadAnimations () {
        // Load the character in the idle animation
        let idleScene = SCNScene(named: "art.scnassets/TrumpAnimations/IdleFixed.dae")!
        
        let trumpNode = SCNNode()
        trumpNode.name = "trumpNode_animator"
        
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            trumpNode.addChildNode(child)
        }
        
        // Set up some properties
        trumpNode.scale = SCNVector3(0.001, 0.001, 0.001)
        node.addChildNode(trumpNode)
        
        // Load all the DAE animations
        DispatchQueue.main.async {
            self.loadAnimation(withKey: "crunch", sceneName: "art.scnassets/TrumpAnimations/biCrunch", animationIdentifier: "biCrunch-1")
            self.loadAnimation(withKey: "jump", sceneName: "art.scnassets/TrumpAnimations/jump", animationIdentifier: "jump-1")
            self.loadAnimation(withKey: "twerk", sceneName: "art.scnassets/TrumpAnimations/Twerk", animationIdentifier: "Twerk-1")
        }
    }
    
    func addParentToChildNode(parentNode: SCNNode) {
        parentNode.addChildNode(node)
    }
    
    func anchorNodeToScene(sceneView: ARSCNView) {
        // Add the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func loadAnimation(withKey: String, sceneName: String, animationIdentifier: String) {
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
    
    func updateAnimatorForHero(heroIn: HeroImpl, node: SCNNode) {
        let animator = Animator(heroToAnimate: heroIn, sceneNode: node)
        Animators.animeDict.updateValue(animator, forKey: heroIn.heroName)
    }
}
