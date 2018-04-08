//
//  GameScene.swift
//  UnnamdedTCGRPG
//
//  Created by Andrew Haentjens on 08/04/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "female_idle")
    
    var playerLookToRight: Bool = true
    var playerWalkAnimation = [SKTexture]()
    
    override func sceneDidLoad() {

        backgroundColor = SKColor.white
        
        initCharacter()
        initWalkScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard
            touches.count == 1,
            let touch = touches.first else { return }

        let location = touch.location(in: self)
        makePlayerWalkToward(location: location, resetAnimation: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        makePlayerStop()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        makePlayerStop()
    }
    
    func initCharacter() {
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        addChild(player)
    }
    
    func initWalkScene() {
        let walkAtlas = SKTextureAtlas(named: "female_walk")
        
        for i in 1...walkAtlas.textureNames.count {
            let imgName = String(format: "female_walk%01d.png", i)
            playerWalkAnimation.append(walkAtlas.textureNamed(imgName))
        }
    }
    
    func makePlayerWalkToward(location: CGPoint, resetAnimation: Bool = false) {
        
        
        if location.x < player.frame.midX {
            if playerLookToRight {
                player.xScale = -1
                playerLookToRight = !playerLookToRight
            }
            
        } else {
            if !playerLookToRight {
                player.xScale = 1
                playerLookToRight = !playerLookToRight
            }
        }
        
        let moveAnimation = SKAction.move(to: location, duration: 0.3)
        
        if resetAnimation {
            let walkAnimation = SKAction.animate(with: self.playerWalkAnimation, timePerFrame: 0.1)
            let walkAnimationSequence = SKAction.repeatForever(walkAnimation)
        
            player.run(walkAnimationSequence)
        }
        
        player.run(moveAnimation) {
            self.makePlayerStop()
        }
    }
    
    func makePlayerStop() {
        player.removeAllActions()
        player.texture = SKTexture(image: #imageLiteral(resourceName: "female_idle"))
    }
    
}
