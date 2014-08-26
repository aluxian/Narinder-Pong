//
//  HighScoresScene.swift
//  Narinder Pong
//
//  Created by Alexandru Rosianu on 26/08/14.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

class HighScoresScene: GameScene, UITableViewDataSource {
    
    var backgroundImg: String!
    var highscores: NSArray?
    var table: UITableView!
    
    init(size: CGSize, bg: String) {
        super.init(size: size)
        self.backgroundImg = bg
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // Load background
        background(backgroundImg)
        
        // UI
        create_title()
        create_btn_back()
        create_table()
        
        view.addSubview(table)
        
        // Data
        if let hs = NSUserDefaults.standardUserDefaults().arrayForKey("highscores") {
            highscores = hs.sorted({ (h1: AnyObject, h2: AnyObject) -> Bool in
                let s1 = NSString(string: ((h1 as NSString).componentsSeparatedByString("___") as [String])[1]).intValue
                let s2 = NSString(string: ((h2 as NSString).componentsSeparatedByString("___") as [String])[1]).intValue
                
                return s1 > s2
            })
        }
        
        // Fade in
        UIView.animateWithDuration(0.6, delay: 0.4, options: nil, animations: {
            self.table.alpha = 1
        }, completion: nil)
    }
    
    // CREATE FUNCTIONS
    
    func create_title() {
        let title = SKSpriteNode(imageNamed: "btn_highscores")
        
        title.position = CGPoint(x: 160, y: 500)
        
        addChild(title)
    }
    
    func create_btn_back() {
        let btn_back = INSKButtonNode(imageNamed: "btn_back")
        
        btn_back.position = CGPoint(x: 160, y: 80)
        btn_back.setTouchUpInsideTarget(self, selector: "back_touch")
        
        addChild(btn_back)
    }
    
    func create_table() {
        table = UITableView(frame: CGRect(x: 20, y: 130, width: 280, height: 300))
        
        table.dataSource = self
        table.alpha = 0
        
        table.backgroundColor = UIColor(white: 0, alpha: 0)
        table.separatorColor = UIColor(white: 0, alpha: 0)
    }
    
    // TOUCH HANDLERS
    
    func back_touch() {
        // Sound
        runAction(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
        
        // Fade out
        UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: {
            self.table.alpha = 0
        }, completion: { (Bool) in
            self.table.removeFromSuperview()
        })
        
        // Switch scene
        scene.view.presentScene(MenuScene(size: size), transition: SKTransition.fadeWithDuration(1))
    }
    
    // IMPLEMENTATIONS
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if let hs = highscores {
            return hs.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: table.frame.width, height: 30))
        let split = (highscores?.objectAtIndex(indexPath.row) as NSString).componentsSeparatedByString("___") as [String]
        
        cell.backgroundColor = UIColor(white: 0, alpha: 0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.textLabel.text = split[0]
        cell.textLabel.textColor = UIColor(red: 0, green: 249/255, blue: 1, alpha: 1)
        
        let scoreLabel = UILabel(frame: CGRect(x: 185, y: 6, width: 80, height: 30))
        scoreLabel.font = cell.textLabel.font
        
        scoreLabel.text = split[1]
        scoreLabel.textColor = UIColor(red: 0, green: 249/255, blue: 1, alpha: 1)
        scoreLabel.textAlignment = NSTextAlignment.Right
        
        cell.contentView.addSubview(scoreLabel)
        return cell
    }
    
}
