//
//  MenuScene.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 24/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import AVFoundation.AVAudioPlayer

class MenuScene: GameScene {
    
    var narinder_player: AVAudioPlayer!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // Load sprites
        create_title()
        create_narinder_head()
        
        create_btn_start()
        create_btn_highscores()
        create_btn_settings()
        
        // Narinder sound player
        narinder_player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pbbbt", ofType: "mp3")!, isDirectory: false), error: nil)
        narinder_player.prepareToPlay()
        
        // Load background
        background(Scenes["Menu"]!["Background"]!)
    }
    
    // CREATE FUNCTIONS
    
    func create_title() {
        let title = SKSpriteNode(imageNamed: "txt_title")
        
        title.position = CGPoint(x: CGRectGetMidX(frame), y: 460)
        
        addChild(title)
    }
    
    func create_btn_start() {
        let btn_start = INSKButtonNode(imageNamed: "btn_start")
        
        btn_start.position = CGPoint(x: 160, y: 320)
        btn_start.setTouchUpInsideTarget(self, selector: "start_touch")
        
        addChild(btn_start)
    }
    
    func create_btn_highscores() {
        let btn_highscores = INSKButtonNode(imageNamed: "btn_highscores")
        
        btn_highscores.position = CGPoint(x: 160, y: 260)
        btn_highscores.setTouchUpInsideTarget(self, selector: "highscores_touch")
        
        addChild(btn_highscores)
    }
    
    func create_btn_settings() {
        let btn_settings = INSKButtonNode(imageNamed: "btn_settings")
        
        btn_settings.position = CGPoint(x: 160, y: 200)
        btn_settings.setTouchUpInsideTarget(self, selector: "settings_touch")
        
        addChild(btn_settings)
    }
    
    func create_narinder_head() {
        let narinder_head = SKSpriteNode(imageNamed: "narinder_head.png")
        narinder_head.position = CGPoint(x: 160, y: 100)
        
        narinder_head.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.moveToX(-100, duration: 0),
            SKAction.waitForDuration(5),
            SKAction.runBlock({
                self.narinder_player.play()
                return
            }),
            SKAction.moveToX(400, duration: 11)
        ])))
        
        addChild(narinder_head)
    }
    
    // TOUCH HANDLERS
    
    func start_touch() {
        // Sounds
        narinder_player.stop()
        runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        // Switch scene
        scene.view.presentScene(LevelScene(size: size, level: 1, score: 0), transition: SKTransition.fadeWithDuration(1))
    }
    
    func highscores_touch() {
        // Sounds
        narinder_player.stop()
        runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        // Switch scene
        scene.view.presentScene(HighScoresScene(size: size, bg: Scenes["Menu"]!["Background"]!), transition: SKTransition.fadeWithDuration(1))
    }
    
    func settings_touch() {
        // Sounds
        narinder_player.stop()
        runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        // Switch scene
        scene.view.presentScene(SettingsScene(size: size), transition: SKTransition.fadeWithDuration(1))
    }
    
}
