//
//  GameScene.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 25/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Scenes configuration properties
    let Scenes = [
        "Menu": [
            "Background": "bg_0.jpg"
        ],
        "Level_1": [
            "Background": "bg_0.jpg"
        ],
        "Level_2": [
            "Background": "bg_1.jpg"
        ],
        "Level_3": [
            "Background": "bg_2.jpg"
        ],
        "Level_4": [
            "Background": "bg_0.jpg"
        ],
        "Level_5": [
            "Background": "bg_0.jpg"
        ]
    ]
    
    // Background nodes
    var background_1: SKSpriteNode!
    var background_2: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        // Change scene gravity & set contact delegate
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    override func update(currentTime: NSTimeInterval) {
        // Scroll the background nodes
        background_1.position.y -= 1
        background_2.position.y -= 1
        
        if background_1.position.y < -background_1.size.height {
            background_1.position.y = background_2.position.y + background_2.size.height
        }
        
        if background_2.position.y < -background_2.size.height {
            background_2.position.y = background_1.position.y + background_1.size.height
        }
    }
    
    // Create the background nodes
    func background(imageNamed: String) {
        // Create the nodes for the scrolling background
        background_1 = SKSpriteNode(imageNamed: imageNamed)
        background_1.position = CGPointMake(0, 0)
        background_1.zPosition = -10
        
        background_2 = SKSpriteNode(imageNamed: imageNamed)
        background_2.position = CGPointMake(0, background_1.size.height)
        background_2.zPosition = -10
        
        // Add children
        addChild(background_1)
        addChild(background_2)
    }
    
    // Slice the spritesheet for the given name and return an array of textures
    func sliceSpriteSheet(name: String, num: Int) -> [SKTexture] {
        let sheet = SKTexture(imageNamed: name)
        sheet.filteringMode = SKTextureFilteringMode.Nearest
        
        let width = 1 / CGFloat(num)
        var frames = [SKTexture]()
        
        for i in 0..<num {
            frames.append(SKTexture(rect: CGRect(x: CGFloat(i) * width, y: 0, width: width, height: 1), inTexture: sheet))
        }
        
        return frames
    }
    
    // Calculates the magnitude of a vector
    func magnitude(vector: CGVector) -> CGFloat {
        return sqrt(pow(vector.dx, 2) + pow(vector.dy, 2))
    }
    
    // Calculates the direction of the given vector in radians
    func direction(vector: CGVector) -> Float {
        return atan2(Float(vector.dy), Float(vector.dx))
    }
    
    // Calculates the velocity for the given speed and direction
    func velocity(speed: CGFloat, direction: Float) -> CGVector {
        return CGVectorMake(speed * CGFloat(cosf(direction)), speed * CGFloat(sinf(direction)))
    }
    
    // Returns the bigger CGFloat
    func max(a: CGFloat, b: CGFloat) -> CGFloat {
        return a > b ? a : b
    }
    
    // Returns the smaller CGFloat
    func min(a: CGFloat, b: CGFloat) -> CGFloat {
        return a < b ? a : b
    }
    
    // Returns a randomly chosen Bool value
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 1
    }

    // Returns a random number in the range [min...max)
    func random(min: Float, max: Float) -> Float {
        return random(max - min) + min
    }
    
    // Returns a random number in the range [0...max)
    func random(max: Float) -> Float {
        return Float(arc4random_uniform(UInt32(max * 100))) / 100
    }
    
    // Returns a random number in the range [0...max)
    func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
    
}
