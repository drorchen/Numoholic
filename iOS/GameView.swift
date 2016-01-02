//
//  GameView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class GameView: NumViewController {
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var game: Game!
    var level: Int!
    var xGrid: Int!
    var yGrid: Int!
    var timer: CGFloat!
    var switches: Int!
    var tSwitches: Int!
    var fSwitches: Int!
    var mode: Int!
    var gameLoaded: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        levelLabel.text = getLevelLabel()
        
        styleTheBackButton(backButton)
        styleHeaderLabel(levelLabel)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !gameLoaded! {
            if level > 0 {
                let currentLevel = Level(level: self.level)
                game = Game (grid: currentLevel.createLevel(0, yGrid: 0, timerInt: 0, switchesNum: 0, tSwitchesNum: 0, fSwitchesNum: 0, mode: 0), level: currentLevel, view: self.view)
                gameLoaded = true
            }
                
            else {
                let currentLevel = Level(level: 0)
                game = Game (grid: currentLevel.createLevel(self.xGrid, yGrid: self.yGrid, timerInt: self.timer, switchesNum: self.switches, tSwitchesNum: self.tSwitches, fSwitchesNum: self.fSwitches, mode: self.mode), level: currentLevel, view: self.view)
                gameLoaded = true
            }
            
            let mainQueue = NSOperationQueue.mainQueue()
            NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationUserDidTakeScreenshotNotification,
                object: nil,
                queue: mainQueue) { notification in
                    self.game.cheater()
            }
        }
    }
    
    func getLevelLabel () -> String {
        if level > 0 {
            return "\(NSLocalizedString("Level", comment: "Level")) \(self.level)"
        }
            
        else {
            return "\(self.xGrid)x\(self.yGrid) \(NSLocalizedString("level", comment: "level"))"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        game.startTimer.invalidate()
        self.navigationController?.popToViewController(currentChooseAGameView, animated: true)
    }
    
}
