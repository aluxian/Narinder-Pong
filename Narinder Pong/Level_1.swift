//
//  Level_1.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 24/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import SpriteKit

class Level_1: SKScene {
    
    var background_1: SKSpriteNode!
    var background_2: SKSpriteNode!
    
    var paddle: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        // Change scene gravity
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        // Scrolling background
        background_1 = SKSpriteNode(imageNamed: "bg_1.jpg")
        background_1.position = CGPointMake(512, 0)
        background_1.zPosition = -1
        
        background_2 = SKSpriteNode(imageNamed: "bg_1.jpg")
        background_2.position = CGPointMake(512, background_1.size.height - 1)
        background_2.zPosition = -1
        
        // Paddle
        paddle = SKSpriteNode(imageNamed: "paddle.png")
        paddle.position = CGPoint(x: 512, y: 125)
        paddle.physicsBody = SKPhysicsBody(polygonFromPath: CGPathCreateWithRoundedRect(CGRect(x: 0, y: 0, width: 150, height: 25), 3, 3, nil))
        
        // Add children
        self.addChild(background_1)
        self.addChild(background_2)
        self.addChild(paddle)
    }
    
    override func update(currentTime: NSTimeInterval) {
        // Scroll background images
        background_1.position = CGPointMake(background_1.position.x, background_1.position.y - 2)
        background_2.position = CGPointMake(background_2.position.x, background_2.position.y - 2)
        
        if background_1.position.y < -background_1.size.height {
            background_1.position = CGPointMake(background_1.position.x, background_2.position.y + background_2.size.height)
        }
        
        if background_2.position.y < -background_2.size.height {
            background_2.position = CGPointMake(background_2.position.x, background_1.position.y + background_1.size.height)
        }
    }
    
}
