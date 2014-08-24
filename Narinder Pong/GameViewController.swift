//
//  GameViewController.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 24/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {

    var backgroundMusic: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Play background music
        let pathToBackGroundMusic = NSBundle.mainBundle().pathForResource("spip_floating_in_space", ofType: "mp3")
        backgroundMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: pathToBackGroundMusic!), error: nil)
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.volume = 0.8
        //backgroundMusic.play()

        // Configure the view
        let skView = self.view as SKView
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        // Display the main scene
        let menuScene = MenuScene(size: CGSize(width: 1024, height: 768))
        menuScene.scaleMode = SKSceneScaleMode.AspectFill
        
        skView.presentScene(menuScene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
