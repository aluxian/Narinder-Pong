//
//  GameViewController.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 24/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameViewController: UIViewController {

    var backgroundMusic: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Play background music
        let pathToBackGroundMusic = NSBundle.mainBundle().pathForResource("song_\(arc4random_uniform(1))", ofType: "mp3")
        backgroundMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: pathToBackGroundMusic!), error: nil)
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.volume = 0.3
        backgroundMusic.play()

        // Configure the view
        let skView = self.view as SKView
        
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        //skView.showsPhysics = true
        
        // SpriteKit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        // Display the main scene
        skView.presentScene(MenuScene(size: skView.frame.size))
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
