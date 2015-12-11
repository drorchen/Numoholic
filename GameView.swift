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
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var game: Game!
    var level: Int!
    var xGrid: Int!
    var yGrid: Int!
    var timer: CGFloat!
    var switches: Int!
    var mode: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if level > 0 {
            levelLabel.text = "\(NSLocalizedString("Level", comment: "Level")) \(self.level)"
        }
            
        else {
            levelLabel.text = "\(self.xGrid)x\(self.yGrid) \(NSLocalizedString("level", comment: "level"))"
        }
        
        backButton.layer.cornerRadius = 10
        backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    override func viewDidAppear(animated: Bool) {
        if level > 0 {
            let currentLevel = Level(level: self.level)
            game = Game (grid: currentLevel.createLevel(0, yGrid: 0, timerInt: 0, switchesNum: 0, mode: 0), timerInt: currentLevel.timer, switchTimes: currentLevel.switchTimes, mode: currentLevel.mode, view: self.view)
        }
            
        else {
            let currentLevel = Level(level: 0)
            game = Game (grid: currentLevel.createLevel(self.xGrid, yGrid: self.yGrid, timerInt: self.timer, switchesNum: self.switches, mode: self.mode), timerInt: currentLevel.timer, switchTimes: currentLevel.switchTimes, mode: currentLevel.mode, view: self.view)
        }
        
        let mainQueue = NSOperationQueue.mainQueue()
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationUserDidTakeScreenshotNotification,
            object: nil,
            queue: mainQueue) { notification in
                self.game.cheater()
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
