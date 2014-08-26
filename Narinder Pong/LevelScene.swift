//
//  LevelScene.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 25/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import SpriteKit

class LevelScene: GameScene {
    
    // Collision bitmasks
    struct Bitmask {
        static let Ball             : UInt32 = 0b00000001
        static let Enemy            : UInt32 = 0b00000010
        static let KillZone         : UInt32 = 0b00000100
        static let Paddle           : UInt32 = 0b00001000
        static let View             : UInt32 = 0b00010000
    }
    
    // Ball constants
    struct Ball {
        static let init_speed: CGFloat = 300
        static let min_speed: CGFloat = 100
        static let max_speed: CGFloat = 400
    }
    
    // Paddle constants
    struct Paddle {
        static let speed: CGFloat = 4
    }
    
    // Levels
    let Levels = [
        1: [
            "enemy_sprite": "zombie_spr_strip4.png",
            "sprites_no": 4,
            "offset_h": 20,
            "offset_v": 20,
            "spacing": -5,
            "columns": 5,
            "rows": 3,
            "padding": 28,
            "timePerFrame": 0.75,
            "sounds": ["enemymove1.wav", "enemymove2.wav", "enemymove3.wav", "enemymove4.wav", "enemymove5.wav"]
        ],
        
        2: [
            "enemy_sprite": "headtheball1_spr_strip10.png",
            "sprites_no": 10,
            "offset_h": 0,
            "offset_v": 0,
            "spacing": 15,
            "columns": 5,
            "rows": 3,
            "padding": 22,
            "timePerFrame": 0.2,
            "sounds": ["Quack-Quack6.mp3"]
        ],
        
        3: [
            "enemy_sprite": "tinyroid1_spr_strip8.png",
            "sprites_no": 8,
            "offset_h": 0,
            "offset_v": 0,
            "spacing": 15,
            "columns": 4,
            "rows": 3,
            "padding": 28,
            "timePerFrame": 0.75,
            "sounds": ["enemy3.wav", "enemyb1.wav", "enemyb2.wav"]
        ],
        
        4: [
            "enemy_sprite": "devil5_spr_strip4.png",
            "sprites_no": 4,
            "offset_h": 20,
            "offset_v": 20,
            "spacing": 0,
            "columns": 6,
            "rows": 3,
            "padding": 22,
            "timePerFrame": 0.75,
            "sounds": ["robotspawn1.wav", "robotspawn2.wav"]
        ],
        
        5: [
            "enemy_sprite": "narinder_head.png",
            "sprites_no": 1,
            "offset_h": 0,
            "offset_v": 0,
            "spacing": 5,
            "columns": 3,
            "rows": 3,
            "padding": 22,
            "timePerFrame": 0.75,
            "sounds": ["robotspawn1.wav", "robotspawn2.wav"]
        ]
    ]
    
    // Sprites
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var bladesaw: SKSpriteNode!
    
    // Nodes
    var viewFrame: SKNode!
    var killzone: SKNode!
    var scoreLabel: SKLabelNode!
    
    // Switches
    var ball_dead = false
    var game_over = false
    
    // Counters
    var enemies_num = 0
    var current_level = 1
    var current_score = 0
    
    // Others
    var last_touch: CGPoint?
    let selected_difficulty = CGFloat(NSUserDefaults.standardUserDefaults().integerForKey("selected_difficulty"))
    
    init(size: CGSize, level: Int, score: Int) {
        super.init(size: size)
        
        current_level = level
        current_score = score
    }
    
    // OVERRIDES
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // Create sprites
        create_ball()
        create_paddle()
        create_bladesaw()
        
        create_viewFrame()
        create_killzone()
        
        create_level_label()
        create_score_label()
        
        // Add children
        addChild(ball)
        addChild(paddle)
        addChild(bladesaw)
        
        addChild(viewFrame)
        addChild(killzone)
        addChild(scoreLabel)
        
        // Don't forget about enemies
        create_enemies()
        
        // Load background
        background(Scenes["Level_\(current_level)"]!["Background"]!)
        
        // Show initial score
        update_score()
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        // Move the paddle towards the finger
        if let touch = last_touch {
            paddle.physicsBody.velocity = CGVector((touch.x - paddle.position.x) * (Paddle.speed - selected_difficulty * 0.5), 0)
        }
        
        // Make sure the ball isn't moving too fast
        let max_speed = Ball.max_speed + selected_difficulty * 200
        if magnitude(ball.physicsBody.velocity) > max_speed {
            ball.physicsBody.velocity = velocity(max_speed, direction: direction(ball.physicsBody.velocity))
        }
        
        // Or too slow, unless it's stationary or dead
        let min_speed = Ball.min_speed + selected_difficulty * 100
        if !ball_dead && magnitude(ball.physicsBody.velocity) < min_speed && magnitude(ball.physicsBody.velocity) != 0 {
            ball.physicsBody.velocity = velocity(min_speed, direction: direction(ball.physicsBody.velocity))
        }
    }
    
    // IMPLEMENTATIONS
    
    func didBeginContact(contact: SKPhysicsContact!) {
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
        if bodyA.categoryBitMask > bodyB.categoryBitMask {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        // Ball - Paddle, View
        if bodyA.categoryBitMask == Bitmask.Ball && bodyB.categoryBitMask == Bitmask.Paddle || bodyB.categoryBitMask == Bitmask.View {
            contact_ball__paddle_view(bodyA, bodyB: bodyB)
        }
        
        // Ball - KillZone
        if bodyA.categoryBitMask == Bitmask.Ball && bodyB.categoryBitMask == Bitmask.KillZone {
            contact_ball__killzone(bodyA, bodyB: bodyB)
        }
        
        // Ball - Enemy
        if bodyA.categoryBitMask == Bitmask.Ball && bodyB.categoryBitMask == Bitmask.Enemy {
            contact_ball__enemy(bodyA, bodyB: bodyB)
        }
    }
    
    // CONTACT FUNCTIONS
    
    func contact_ball__paddle_view(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) {
        ball.runAction(SKAction.playSoundFileNamed("antspawn_bip.wav", waitForCompletion: false))
        ball.physicsBody.applyAngularImpulse(randomBool() ? 0.000025 : -0.000025)
    }
    
    func contact_ball__killzone(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) {
        ball.runAction(SKAction.sequence([
            SKAction.waitForDuration(0.25),
            SKAction.playSoundFileNamed(randomBool() ? "dying.wav" : "wilhelmscream.wav", waitForCompletion: false)
            ]))
        
        // Animate the bladesaw
        bladesaw.runAction(SKAction.sequence([
            SKAction.moveTo(CGPoint(x: frame.width + bladesaw.frame.width / 2, y: ball.frame.origin.y - bladesaw.frame.height / 2 - 20), duration: 0),
            SKAction.playSoundFileNamed("bladesaw.wav", waitForCompletion: false),
            SKAction.moveToX(-(bladesaw.frame.width / 2), duration: 1),
            SKAction.waitForDuration(1),
            SKAction.runBlock({
                let selected = NSUserDefaults.standardUserDefaults().integerForKey("selected_ball")
                
                let gameOver = SKSpriteNode(imageNamed: selected == 0 ? "txt_killed.png" : "txt_killed2.png")
                gameOver.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 30)
                gameOver.zPosition = 100
                
                self.addChild(gameOver)
                self.game_over = true
            }),
            SKAction.playSoundFileNamed("gemchange.wav", waitForCompletion: false)
        ]))
        
        ball.physicsBody.linearDamping = magnitude(ball.physicsBody.velocity) / 100
        ball.physicsBody.angularDamping = fabs(ball.physicsBody.angularVelocity) / 2
        
        ball_dead = true
    }
    
    func contact_ball__enemy(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) {
        let sounds = Levels[current_level]!["sounds"]! as [String]
        let sound = sounds[random(sounds.count)]
        
        bodyB.node.runAction(SKAction.sequence([
            SKAction.playSoundFileNamed(sound, waitForCompletion: false),
            SKAction.runBlock({
                let path = NSBundle.mainBundle().pathForResource("EnemyExplosion", ofType: "sks")
                let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as SKEmitterNode
                
                explosion.position = bodyB.node.position
                explosion.particleTexture = (bodyB.node as SKSpriteNode).texture
                
                explosion.runAction(SKAction.sequence([
                    SKAction.scaleTo(0.3, duration: 0),
                    SKAction.fadeAlphaTo(0, duration: 0.3),
                    SKAction.removeFromParent()
                ]))
                
                self.addChild(explosion)
                self.enemies_num--
                
                if self.enemies_num == 0 {
                    self.ball_dead = true
                    
                    self.ball.physicsBody.linearDamping = self.magnitude(self.ball.physicsBody.velocity) / 100
                    self.ball.physicsBody.angularDamping = fabs(self.ball.physicsBody.angularVelocity) / 2
                    
                    self.runAction(SKAction.sequence([
                        SKAction.waitForDuration(0.5),
                        SKAction.runBlock({
                            if self.current_level == self.Levels.count {
                                let gameFinished = SKSpriteNode(imageNamed: "txt_finished.png")
                                gameFinished.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 30)
                                gameFinished.zPosition = 100
                                
                                self.addChild(gameFinished)
                                self.game_over = true
                            } else {
                                self.next_level()
                            }
                        })
                    ]))
                }
                
                self.increase_score(1000 + Int(self.selected_difficulty) * 100)
            }),
            SKAction.fadeAlphaTo(0, duration: 0.1),
            SKAction.removeFromParent()
        ]))
    }
    
    // CREATE FUNCTIONS
    
    func create_ball() {
        let selected = NSUserDefaults.standardUserDefaults().integerForKey("selected_ball")
        
        if selected == 4 {
            let frames = sliceSpriteSheet("ball_4.png", num: 4)
            ball = SKSpriteNode(texture: frames[0])
            ball.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(frames, timePerFrame: 0.75)))

        } else {
            ball = SKSpriteNode(imageNamed: "ball_\(selected).png")
        }
        
        ball.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        ball.alpha = 0
        
        ball.runAction(SKAction.sequence([
            SKAction.scaleTo(30 / ball.frame.width, duration: 0),
            SKAction.playSoundFileNamed("allspawn.wav", waitForCompletion: false),
            SKAction.fadeAlphaTo(1, duration: 0.35),
            SKAction.fadeAlphaTo(0, duration: 0.35),
            SKAction.fadeAlphaTo(1, duration: 0.35),
            SKAction.fadeAlphaTo(0, duration: 0.35),
            SKAction.fadeAlphaTo(1, duration: 0.35),
            SKAction.waitForDuration(0.5),
            SKAction.playSoundFileNamed("s2.wav", waitForCompletion: false),
            SKAction.runBlock({
                self.ball.physicsBody.velocity = self.velocity(Ball.init_speed, direction: self.random(Float(M_PI / 3), max: Float(M_PI / 3 * 2)) + Float(self.randomBool() ? M_PI : 0))
            })
        ]))
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width / 2)
        ball.physicsBody.mass = 0.00000001
        
        ball.physicsBody.linearDamping = selected_difficulty * -0.08 - 0.02
        ball.physicsBody.angularDamping = 0
        
        ball.physicsBody.friction = 0
        ball.physicsBody.restitution = 1
        
        ball.physicsBody.categoryBitMask = Bitmask.Ball
        ball.physicsBody.collisionBitMask = Bitmask.View | Bitmask.Paddle | Bitmask.Enemy
        ball.physicsBody.contactTestBitMask = Bitmask.View | Bitmask.Paddle | Bitmask.Enemy | Bitmask.KillZone
    }
    
    func create_paddle() {
        paddle = SKSpriteNode(imageNamed: "paddle.png")
        paddle.position = CGPoint(x: CGRectGetMidX(frame), y: 90)
        
        paddle.physicsBody = SKPhysicsBody(polygonFromPath: CGPathCreateWithRoundedRect(CGRect(x: -62.5, y: -10, width: 125, height: 20), 3, 3, nil))
        paddle.physicsBody.allowsRotation = false
        
        paddle.physicsBody.linearDamping = 1
        paddle.physicsBody.angularDamping = 1
        
        paddle.physicsBody.categoryBitMask = Bitmask.Paddle
        paddle.physicsBody.collisionBitMask = Bitmask.View
    }
    
    func create_bladesaw() {
        bladesaw = SKSpriteNode(imageNamed: "blade.png")
        bladesaw.position = CGPoint(x: -(bladesaw.frame.width / 2), y: 0)
        
        bladesaw.physicsBody = SKPhysicsBody(circleOfRadius: bladesaw.size.width / 2)
        bladesaw.physicsBody.angularVelocity = 4
        
        bladesaw.physicsBody.categoryBitMask = 0
        bladesaw.physicsBody.collisionBitMask = 0
    }
    
    func create_viewFrame() {
        viewFrame = SKNode()
        
        viewFrame.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        viewFrame.physicsBody.categoryBitMask = Bitmask.View
        
        viewFrame.physicsBody.restitution = 0
        viewFrame.physicsBody.friction = 0
    }
    
    func create_killzone() {
        killzone = SKNode()
        
        killzone.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: -5, y: -5, width: frame.width + 10, height: paddle.position.y - 5))
        killzone.physicsBody.categoryBitMask = Bitmask.KillZone
        
        killzone.physicsBody.restitution = 0
        killzone.physicsBody.friction = 0
    }
    
    func create_enemies() {
        let frames = sliceSpriteSheet(Levels[current_level]!["enemy_sprite"]! as String, num: Levels[current_level]!["sprites_no"]! as Int)
        
        let offset_h = Levels[current_level]!["offset_h"]! as CGFloat
        let offset_v = Levels[current_level]!["offset_v"]! as CGFloat
        let spacing = Levels[current_level]!["spacing"]! as Int
        let columns = Levels[current_level]!["columns"]! as Int
        let rows = Levels[current_level]!["rows"]! as Int
        let padding = Levels[current_level]!["padding"]! as Int
        let timePerFrame = Levels[current_level]!["timePerFrame"]! as NSTimeInterval
        
        for row in 0..<rows {
            for col in 0..<columns {
                let enemy = SKSpriteNode(texture: frames[0])
                enemy.setScale(min(60 / max(enemy.size.width, b: enemy.size.height), b: 1))
                
                let origin = CGPoint(x: (frame.width - CGFloat(columns * Int(enemy.size.width) + (columns - 1) * spacing)) / 2, y: 500)
                enemy.position = CGPoint(x: CGFloat(padding) + origin.x + CGFloat(col * (Int(enemy.size.width) + spacing)), y: origin.y - CGFloat(row * (Int(enemy.size.height) + spacing)))
                
                let pathSize = CGSize(width: enemy.frame.width - offset_h, height: enemy.frame.height - offset_v)
                let pathRect = CGRect(origin: CGPoint(x: -(pathSize.width / 2), y: -(pathSize.height / 2)), size: pathSize)
                
                enemy.physicsBody = SKPhysicsBody(polygonFromPath: CGPathCreateWithRect(pathRect, nil))
                enemy.physicsBody.categoryBitMask = Bitmask.Enemy
                
                // Animate the frames
                enemy.runAction(SKAction.group([
                    SKAction.repeatActionForever(SKAction.animateWithTextures(frames, timePerFrame: timePerFrame)),
                    SKAction.repeatActionForever(SKAction.sequence([
                        SKAction.waitForDuration(3),
                        SKAction.moveByX(0, y: -10, duration: 0),
                        SKAction.runBlock({
                            self.increase_score(-100)
                            
                            if self.game_over {
                                enemy.position.y += 10
                            }
                        })
                    ]))
                ]))
                
                enemies_num++
                self.addChild(enemy)
            }
        }
    }
    
    func create_level_label() {
        let levelLabel = SKLabelNode(text: "Level \(current_level)")
        
        levelLabel.position = CGPoint(x: frame.width - 20, y: 540)
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        levelLabel.fontSize = 16
        levelLabel.fontName = "Helvetica-Bold"
        levelLabel.fontColor = UIColor(red: 0, green: 249/255, blue: 1, alpha: 1)
        
        addChild(levelLabel)
    }
    
    func create_score_label() {
        scoreLabel = SKLabelNode()
        
        scoreLabel.position = CGPoint(x: 20, y: 540)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        scoreLabel.fontSize = 16
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontColor = UIColor(red: 0, green: 249/255, blue: 1, alpha: 1)
    }
    
    // TOUCH HANDLERS
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        last_touch = (touches.anyObject() as UITouch).locationInNode(self)
        paddle.physicsBody.restitution = 0
        
        if game_over {
            scene.view.presentScene(SubmitHsScene(size: frame.size, bg: Scenes["Level_\(current_level)"]!["Background"]!, score: current_score), transition: SKTransition.fadeWithDuration(1))
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        last_touch = (touches.anyObject() as UITouch).locationInNode(self)
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        last_touch = nil
        paddle.physicsBody.restitution = 0.5
    }
    
    // UTILS
    
    func next_level() {
        scene.view.presentScene(LevelScene(size: size, level: current_level + 1, score: current_score), transition: SKTransition.fadeWithDuration(1))
    }
    
    func update_score() {
        scoreLabel.text = "Score: \(current_score)"
    }
    
    func increase_score(with: Int) {
        if !game_over {
            current_score += with
            update_score()
        }
    }
    
}
