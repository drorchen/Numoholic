//
//  Game.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class Game: NSObject {
    var grid: Grid!
    var gridView: UIView!
    var buttons: [UIButton]!
    var currentNumber: Int!
    var startTimer: NSTimer!
    var timerInt: CGFloat!
    var switchTimes: Int!
    var switchTimer: NSTimer!
    var mode: Int!
    var target: Int!
    
    init (grid: Grid, timerInt: CGFloat, switchTimes: Int, mode: Int, view: UIView) {
        super.init()

        self.grid = grid
        self.timerInt = timerInt+0.3
        currentNumber = 0
        self.switchTimes = switchTimes
        self.mode = mode
        
        let currentController = currentViewController()!
        
        currentController.timerLabel.text = "\(timerInt)"
        startTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "reduceTimerByOne", userInfo: nil, repeats: true)
        
        gridView = self.grid.createGridView(currentController.view!, label: currentController.levelLabel)
        buttons = self.grid.addButtonsToGridView(gridView)
        
        setButtons()
    }

    func reduceTimerByOne () {
        if timerInt > 0 {
            timerInt = timerInt - 0.1
            timerInt = round(10 * timerInt) / 10
            
            if timerInt == 0 {
                startTimer.invalidate()
                currentViewController()!.timerLabel.removeFromSuperview()
                startTheGame()
            }
            
            else {
                currentViewController()!.timerLabel.text = "\(timerInt)"
            }
        }
    }
    
    func enableAllButtons () {
        for var i = 0; i < buttons.count; i++ {
            buttons[i].enabled = true
            buttons[i].enabled = true
        }
    }
    
    func disableAllButtons () {
        for var i = 0; i < buttons.count; i++ {
            buttons[i].enabled = false
            buttons[i].enabled = false
        }
    }
    
    func switchTiles () {
        if switchTimes > 0 && buttons.count >= 2 {
            disableAllButtons()
            var twoTiles = twoRandomTiles()
            let frameOfTileOne = buttons[twoTiles[0]].frame
            
            UIView.animateWithDuration(0.4, animations: {
                self.buttons[twoTiles[0]].frame = self.buttons[twoTiles[1]].frame
                self.buttons[twoTiles[1]].frame = frameOfTileOne
                }, completion: { (value: Bool) in
                    self.enableAllButtons()
            })
            
            switchTimes!--
            if switchTimes == 0 {
                switchTimer.invalidate()
            }
        }
        
        else {
            switchTimer.invalidate()
        }
    }
    
    func twoRandomTiles () -> [Int] {
        var twoTiles = [Int]()
        let firstTile = Int(arc4random_uniform(UInt32(buttons.count)))
        let secondTile = Int(arc4random_uniform(UInt32(buttons.count)))
        
        if firstTile == secondTile {
            return twoRandomTiles()
        }
            
        else {
            twoTiles.append(firstTile)
            twoTiles.append(secondTile)
            return twoTiles
        }
    }
    
    func startTheGame () {
        switchTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "switchTiles", userInfo: nil, repeats: true)
        for var i = 0; i < buttons.count; i++ {
            let button = buttons[i]
            button.enabled = true
            button.tag = Int((button.titleLabel?.text)!)! as Int
            button.setTitle("", forState: UIControlState.Normal)
        }
        
        if mode == 2 {
            target = randomTarget()
            currentViewController()!.targetLabel.text = "\(NSLocalizedString("Target", comment: "target")): \(target)"
        }
            
        else {
            currentViewController()!.targetLabel.text = "\(NSLocalizedString("Target", comment: "target")): 1"
        }
    }
    
    func setButtons () {
        for var i = 0; i < buttons.count; i++ {
            buttons[i].addTarget(self, action: "clickedAButton:", forControlEvents: UIControlEvents.TouchUpInside)
            buttons[i].exclusiveTouch = true
            buttons[i].enabled = false
        }
    }
    
    func randomTarget () -> Int {
        let target = Int(arc4random_uniform(UInt32(grid.x*grid.y)))+1
        
        var found = false
        for var i = 0; i < buttons.count; i++ {
            if target == buttons[i].tag {
                found = true
            }
        }
        
        if found {
            currentViewController()?.targetLabel.text = "\(NSLocalizedString("Target", comment: "target")): \(target)"
            return target
        }
        
        else {
            return randomTarget()
        }
    }
    
    func clickedAButton (sender: UIButton) {
        if mode == 1 {
            if currentNumber == sender.tag-1 {
                buttons = buttons.filter() { $0 !== sender }
                sender.removeFromSuperview()
                
                if buttons.count == 0 {
                    nextLevel()
                }
                
                else {
                    currentNumber!++
                    currentViewController()?.targetLabel.text = "\(NSLocalizedString("Target", comment: "target")): \(currentNumber+1)"
                }
            }
                
            else {
                wrong()
            }
        }
        
        else if mode == 2 {
            if target == sender.tag {
                buttons = buttons.filter() { $0 !== sender }
                sender.removeFromSuperview()
                
                if buttons.count == 0 {
                    nextLevel()
                }
                
                else {
                    target = randomTarget()
                }
            }
                
            else {
                wrong()
            }
        }
    }
    
    func cheater () {
        if startTimer != nil {
            startTimer.invalidate()
        }
        
        if switchTimer != nil {
            switchTimer.invalidate()
        }
        
        if let currentController = self.currentViewController() {
            currentController.view.userInteractionEnabled = false
            currentController.backButtonPressed(UIButton())
        }
    }
    
    func wrong () {
        let currentController = self.currentViewController()!
        currentController.view.userInteractionEnabled = false
        if switchTimer != nil {
            switchTimer.invalidate()
        }
        
        for var i = 0; i < buttons.count; i++ {
            buttons[i].enabled = false
            buttons[i].backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8)
            buttons[i].setTitle("\(buttons[i].tag)", forState: UIControlState.Normal)
        }
        
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if currentController.level > 0 {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as! GameView
                nextViewController.level = currentController.level
                currentController.navigationController?.pushViewController(nextViewController, animated: true)
            }
                
            else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as! GameView
                nextViewController.level = 0
                nextViewController.xGrid = currentController.xGrid
                nextViewController.yGrid = currentController.yGrid
                nextViewController.timer = currentController.timer
                nextViewController.switches = currentController.switches
                nextViewController.mode = currentController.mode
                currentController.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
    
    func nextLevel () {
        let currentController = self.currentViewController()!
        currentController.view.userInteractionEnabled = false
        if currentController.level > 0 {
            if currentController.level == level {
                level!++
                NSUserDefaults.standardUserDefaults().setObject(level, forKey: "level")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            
            let delay = 0.1 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as! GameView
                nextViewController.level = currentController.level+1
                currentController.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
        
        else {
            currentController.backButtonPressed(UIButton())
        }
    }
    
    func currentViewController () -> GameView? {
        let currentController = (appDelegate.window!.rootViewController as! UINavigationController).topViewController!
        if currentController is GameView {
            return currentController as? GameView
        }
        
        else {
            return nil
        }
    }
    
}
