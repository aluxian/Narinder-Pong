//
//  MenuScene.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 24/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene {
    
    var background_1: SKSpriteNode!
    var background_2: SKSpriteNode!
    
    var narinder_head: SKSpriteNode!
    var narinder_player: AVAudioPlayer!
    
    override func didMoveToView(view: SKView) {
        // Game title
        let title = SKSpriteNode(imageNamed: "txt_title")
        title.position = CGPoint(x: 512, y: 620)
        
        // Start button
        let btn_start = INSKButtonNode(imageNamed: "btn_start")
        btn_start.position = CGPoint(x: 512, y: 400)
        btn_start.setTouchUpInsideTarget(self, selector: "start_touch")
        
        // Highscores button
        let btn_highscores = INSKButtonNode(imageNamed: "btn_highscores")
        btn_highscores.position = CGPoint(x: 512, y: 325)
        btn_highscores.setTouchUpInsideTarget(self, selector: "highscores_touch")
        
        // Scrolling background
        background_1 = SKSpriteNode(imageNamed: "bg_1.jpg")
        background_1.position = CGPointMake(512, 0)
        
        background_2 = SKSpriteNode(imageNamed: "bg_1.jpg")
        background_2.position = CGPointMake(512, background_1.size.height - 1)
        
        // Narinder head
        narinder_head = SKSpriteNode(imageNamed: "narinder_head.png")
        narinder_head.position = CGPoint(x: 0, y: 130)
        narinder_player = AVAudioPlayer(
            contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pbbbt", ofType: "mp3")!, isDirectory: false),
            error: nil)
        
        // Add children
        self.addChild(background_1)
        self.addChild(background_2)
        self.addChild(narinder_head)
        
        self.addChild(title)
        self.addChild(btn_start)
        self.addChild(btn_highscores)
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
        
        // Move Narinder's head
        narinder_head.position.x += 2
        
        if narinder_head.position.x > 1000 {
            narinder_head.position.x = 0
        }
        
        if !narinder_player.playing && narinder_head.position.x == 200 {
            narinder_player.play()
        }
    }
    
    func start_touch() {
        // Sounds
        self.narinder_player.stop()
        self.runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        // Switch scene
        let level1 = Level_1(size: self.size)
        level1.scaleMode = SKSceneScaleMode.AspectFill
        
        self.scene.view.presentScene(level1, transition: SKTransition.fadeWithDuration(1))
    }
    
    func highscores_touch() {
        self.runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
    }
    
}
