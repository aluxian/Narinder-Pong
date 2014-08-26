//
//  SubmitHsScene.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 26/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

class SubmitHsScene: GameScene {
    
    var backgroundImg: String!
    var score: Int!
    var field: UITextField!
    
    init(size: CGSize, bg: String, score: Int) {
        super.init(size: size)
        self.backgroundImg = bg
        self.score = score
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // Load background
        background(backgroundImg)
        
        // UI
        create_title()
        create_btn_submit()
        create_field()
        
        // Add the field
        view.addSubview(field)
        
        // Fade in
        UIView.animateWithDuration(0.6, delay: 0.4, options: nil, animations: {
            self.field.alpha = 1
        }, completion: nil)
    }
    
    // CREATE FUNCTIONS
    
    func create_title() {
        let yourNameLabel = SKSpriteNode(imageNamed: "txt_name")
        
        yourNameLabel.position = CGPoint(x: 160, y: 400)
        
        addChild(yourNameLabel)
    }
    
    func create_btn_submit() {
        let btn_submit = INSKButtonNode(imageNamed: "btn_submit")
        
        btn_submit.setTouchUpInsideTarget(self, selector: "submit_touch")
        btn_submit.position = CGPoint(x: 160, y: 150)
        
        addChild(btn_submit)
    }
    
    func create_field() {
        field = UITextField(frame: CGRect(x: 20, y: 265, width: 280, height: 40))
        field.alpha = 0
        
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(red: 0, green: 249/255, blue: 1, alpha: 1).CGColor!
        
        field.textColor = UIColor(red: 0, green: 249/255, blue: 1, alpha: 1)
        //field.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        field.attributedPlaceholder = NSAttributedString(string: "Player", attributes: [NSForegroundColorAttributeName: field.textColor.colorWithAlphaComponent(0.5)])
        
        // Add left padding
        field.leftView = UIView(frame: CGRectMake(0, 0, 10, field.frame.height))
        field.leftViewMode = UITextFieldViewMode.Always
    }
    
    // TOUCH HANDLERS
    
    func submit_touch() {
        runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        var highscores = [String]()
        
        if let savedHighscores = NSUserDefaults.standardUserDefaults().arrayForKey("highscores") {
            highscores += savedHighscores as [String]
        }
        
        // Save the new highscore
        highscores.append("\(field.text)___\(score)")
        NSUserDefaults.standardUserDefaults().setObject(NSArray(array: highscores), forKey: "highscores")
        
        // Fade out
        UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: {
            self.field.alpha = 0
        }, completion: { (Bool) in
            self.field.removeFromSuperview()
        })
        
        scene.view.presentScene(HighScoresScene(size: frame.size, bg: self.backgroundImg), transition: SKTransition.fadeWithDuration(1))
    }
    
}
