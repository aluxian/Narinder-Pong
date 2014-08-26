//
//  SettingsScene.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 26/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import AVFoundation.AVAudioPlayer

class SettingsScene: GameScene {

    var balls = [INSKButtonNode]()
    var levels = [INSKButtonNode]()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // Load sprites
        create_title_ball()
        create_title_difficulty()
        
        create_btn_back()
        create_balls()
        create_difficulty_levels()
        
        // Load background
        background(Scenes["Menu"]!["Background"]!)
    }
    
    // CREATE FUNCTIONS
    
    func create_title_ball() {
        let title = SKSpriteNode(imageNamed: "txt_ball")
        
        title.position = CGPoint(x: CGRectGetMidX(frame), y: 488)
        
        addChild(title)
    }
    
    func create_title_difficulty() {
        let title = SKSpriteNode(imageNamed: "txt_difficulty")
        
        title.position = CGPoint(x: CGRectGetMidX(frame), y: 258)
        
        addChild(title)
    }
    
    func create_btn_back() {
        let btn_back = INSKButtonNode(imageNamed: "btn_back")
        
        btn_back.position = CGPoint(x: 160, y: 80)
        btn_back.setTouchUpInsideTarget(self, selector: "back_touch")
        
        addChild(btn_back)
    }
    
    func create_balls() {
        let frames = sliceSpriteSheet("ball_4.png", num: 4)
        
        // Create balls
        for i in 0..<4 {
            balls.append(INSKButtonNode(imageNamed: "ball_\(i).png"))
        }
        
        balls.append(INSKButtonNode(texture: frames[0]))
        balls[4].runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(frames, timePerFrame: 0.1)))
        
        // Setup
        for i in 0..<5 {
            balls[i].setTouchUpInsideTarget(self, selector: Selector("ball_\(i)_touch"))
            balls[i].setScale(40 / balls[i].size.width)
            balls[i].alpha = 0.5
            
            addChild(balls[i])
        }
        
        // Position them
        balls[0].position = CGPoint(x: 120, y: 400)
        balls[1].position = CGPoint(x: 200, y: 400)
        balls[2].position = CGPoint(x: 80, y: 340)
        balls[3].position = CGPoint(x: 240, y: 340)
        balls[4].position = CGPoint(x: 160, y: 340)
        
        // Highlight the selected one
        balls[NSUserDefaults.standardUserDefaults().integerForKey("selected_ball")].alpha = 1
    }
    
    func create_difficulty_levels() {
        for i in 0..<3 {
            // Create
            levels.append(INSKButtonNode(imageNamed: ["btn_easy.png", "btn_normal.png", "btn_hard.png"][i]))
            addChild(levels[i])
            
            // Setup
            levels[i].alpha = 0.5
            levels[i].setTouchUpInsideTarget(self, selector: Selector("level_\(i)_touch"))
        }
        
        // Position them
        levels[0].position = CGPoint(x: 160 - 55 - levels[0].frame.width / 2, y: 200)
        levels[1].position = CGPoint(x: 160, y: 200)
        levels[2].position = CGPoint(x: 160 + 55 + levels[2].frame.width / 2, y: 200)
        
        // Highlight the selected one
        levels[NSUserDefaults.standardUserDefaults().integerForKey("selected_difficulty")].alpha = 1
    }
    
    // TOUCH HANDLERS
    
    func back_touch() {
        // Sound
        runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        // Switch scene
        scene.view.presentScene(MenuScene(size: size), transition: SKTransition.fadeWithDuration(1))
    }
    
    func ball_0_touch() {
        ball_touch(0)
    }
    
    func ball_1_touch() {
        ball_touch(1)
    }
    
    func ball_2_touch() {
        ball_touch(2)
    }
    
    func ball_3_touch() {
        ball_touch(3)
    }
    
    func ball_4_touch() {
        ball_touch(4)
    }
    
    func level_0_touch() {
        level_touch(0)
    }
    
    func level_1_touch() {
        level_touch(1)
    }
    
    func level_2_touch() {
        level_touch(2)
    }
    
    func ball_touch(i: Int) {
        // Sound
        runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        // Hide all
        for ball in balls {
            ball.alpha = 0.5
        }
        
        // Show the correct one
        balls[i].alpha = 1
        
        // Save it
        NSUserDefaults.standardUserDefaults().setInteger(i, forKey: "selected_ball")
    }
    
    func level_touch(i: Int) {
        // Sound
        runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        // Hide all
        for level in levels {
            level.alpha = 0.5
        }
        
        // Show the correct one
        levels[i].alpha = 1
        
        // Save it
        NSUserDefaults.standardUserDefaults().setInteger(i, forKey: "selected_difficulty")
    }
    
}
