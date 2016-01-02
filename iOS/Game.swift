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
    var buttonsLeft: Int!
    var currentNumber: Int!
    var startTimer: NSTimer!
    var timerInt: CGFloat!
    var switchTimes: Int!
    var tSwitchTimes: Int!
    var fSwitchTimes: Int!
    var switchTimer: NSTimer!
    var mode: Mode!
    var target: Int!
    var _level: Level!
    private let switchesGroup = dispatch_group_create()
    
    init (grid: Grid, level: Level, view: UIView) {
        super.init()

        self.grid = grid
        self._level = level
        self.timerInt = self._level.timer+0.3
        self.switchTimes = self._level.switchTimes
        self.tSwitchTimes = self._level.tSwitchTimes
        self.fSwitchTimes = self._level.fSwitchTimes
        self.mode = Mode(mode: self._level.mode)
        currentNumber = 0
        target = self.mode.setModeTitle(self)
        
        let currentController = currentViewController()!
        
        currentController.timerLabel.text = "\(timerInt)"
        startTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "reduceTimerByOne", userInfo: nil, repeats: true)
        
        gridView = self.grid.createGridView(currentController.view!, label: currentController.levelLabel)
        buttons = self.grid.addButtonsToGridView(gridView, spacingTargets: mode.spacingTargets())
        self.buttonsLeft = self.buttons.count
        
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
        for button in buttons {
            button.enabled = true
        }
        dispatch_group_leave(switchesGroup)
    }
    
    func disableAllButtons () {
        for button in buttons {
            button.enabled = false
        }
        dispatch_group_leave(switchesGroup)
    }
    
    func switchTwoTiles () {
        dispatch_group_notify(switchesGroup, dispatch_get_main_queue()) {
            if self.switchTimes > 0 && self.buttons.count >= 2 {
                dispatch_group_enter(self.switchesGroup)
                self.disableAllButtons()
                
                dispatch_group_notify(self.switchesGroup, dispatch_get_main_queue()) {
                    if self.buttons.count >= 2 {
                        self.switchTimes = self.switchTiles(self.twoRandomTiles(), counter: self.switchTimes)
                        
                        if self.switchTimes == 0 {
                            self.switchTimer.invalidate()
                        }
                    }
                        
                    else {
                        dispatch_group_enter(self.switchesGroup)
                        self.enableAllButtons()
                        self.switchTimer.invalidate()
                    }
                }
            }
        }
    }
    
    func switchThreeTiles () {
        dispatch_group_notify(switchesGroup, dispatch_get_main_queue()) {
            if self.tSwitchTimes > 0 && self.buttons.count >= 3 {
                dispatch_group_enter(self.switchesGroup)
                self.disableAllButtons()
                
                dispatch_group_notify(self.switchesGroup, dispatch_get_main_queue()) {
                    if self.buttons.count >= 3 {
                        self.tSwitchTimes = self.switchTiles(self.threeRandomTiles(), counter: self.tSwitchTimes)
                    }
                        
                    else {
                        dispatch_group_enter(self.switchesGroup)
                        self.enableAllButtons()
                        self.switchTwoTiles()
                    }
                }
            }
                
            else {
                self.switchTwoTiles()
            }
        }
    }
    
    func switchFourTiles () {
        dispatch_group_notify(switchesGroup, dispatch_get_main_queue()) {
            if self.fSwitchTimes > 0 && self.buttons.count >= 4 {
                dispatch_group_enter(self.switchesGroup)
                self.disableAllButtons()
                
                dispatch_group_notify(self.switchesGroup, dispatch_get_main_queue()) {
                    if self.buttons.count >= 4 {
                        self.fSwitchTimes = self.switchTiles(self.fourRandomTiles(), counter: self.fSwitchTimes)
                    }
                        
                    else {
                        dispatch_group_enter(self.switchesGroup)
                        self.enableAllButtons()
                        self.switchThreeTiles()
                    }
                }
            }
                
            else {
                self.switchThreeTiles()
            }
        }
    }
    
    func switchTiles (tiles: [Int], var counter: Int) -> Int {
        if counter > 0 && buttons.count >= tiles.count {
            var framesOfTiles = [CGRect]()
            for tile in tiles {
                framesOfTiles.append(buttons[tile].frame)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.2, animations: {
                    for var i = 0; i < tiles.count; i++ {
                        self.buttons[tiles[i]].backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8)
                    }
                    }, completion: { (value: Bool) in
                        UIView.animateWithDuration(0.4, animations: {
                            for var i = 0; i < tiles.count-1; i++ {
                                self.buttons[tiles[i]].frame = framesOfTiles[i+1]
                            }
                            self.buttons[tiles[tiles.count-1]].frame = framesOfTiles[0]
                            }, completion: { (value: Bool) in
                                dispatch_group_enter(self.switchesGroup)
                                self.enableAllButtons()
                                UIView.animateWithDuration(0.2, animations: {
                                    for button in self.buttons {
                                        button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
                                    }
                                })
                        })
                })
            }
            
            
            counter--
            return counter
        }
        
        return 0
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
    
    func threeRandomTiles () -> [Int] {
        var threeTiles = [Int]()
        var firstTile: Int!
        var secondTile: Int!
        var thirdTile: Int!
        
        if buttons.count > 3 {
            firstTile = Int(arc4random_uniform(UInt32(buttons.count)))
            secondTile = Int(arc4random_uniform(UInt32(buttons.count)))
            thirdTile = Int(arc4random_uniform(UInt32(buttons.count)))
        }
            
        else {
            firstTile = 0
            secondTile = 1
            thirdTile = 2
        }
        
        if firstTile == secondTile || firstTile == thirdTile || secondTile == thirdTile {
            return threeRandomTiles()
        }
            
        else {
            threeTiles.append(firstTile)
            threeTiles.append(secondTile)
            threeTiles.append(thirdTile)
            return threeTiles
        }
    }
    
    func fourRandomTiles () -> [Int] {
        var fourTiles = [Int]()
        var firstTile: Int!
        var secondTile: Int!
        var thirdTile: Int!
        var fourthTile: Int!
        
        if buttons.count > 4 {
            firstTile = Int(arc4random_uniform(UInt32(buttons.count)))
            secondTile = Int(arc4random_uniform(UInt32(buttons.count)))
            thirdTile = Int(arc4random_uniform(UInt32(buttons.count)))
            fourthTile = Int(arc4random_uniform(UInt32(buttons.count)))
        }
            
        else {
            firstTile = 0
            secondTile = 1
            thirdTile = 2
            fourthTile = 3
        }
        
        if firstTile == secondTile || firstTile == thirdTile || secondTile == thirdTile || firstTile == fourthTile || secondTile == fourthTile || thirdTile == fourthTile {
            return fourRandomTiles()
        }
            
        else {
            fourTiles.append(firstTile)
            fourTiles.append(secondTile)
            fourTiles.append(thirdTile)
            fourTiles.append(fourthTile)
            return fourTiles
        }
    }
    
    func startTheGame () {
        let delay = 1.45 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.switchFourTiles()
            self.switchTimer = NSTimer.scheduledTimerWithTimeInterval(2.15, target: self, selector: "switchFourTiles", userInfo: nil, repeats: true)
        }
        
        for var i = 0; i < buttons.count; i++ {
            let button = buttons[i]
            button.enabled = true
            button.tag = Int((button.titleLabel?.text)!)! as Int
            button.setTitle("", forState: UIControlState.Normal)
        }
        
        setTarget()
    }
    
    func setButtons () {
        for var i = 0; i < buttons.count; i++ {
            buttons[i].addTarget(self, action: "clickedAButton:", forControlEvents: UIControlEvents.TouchUpInside)
            buttons[i].exclusiveTouch = true
            buttons[i].enabled = false
        }
    }
    
    func clickedAButton (sender: UIButton) {
        if target == sender.tag {
            buttons = buttons.filter() { $0 !== sender }
            sender.enabled = false
            sender.hidden = true
            
            if buttons.count == 0 {
                nextLevel()
            }
                
            else {
                currentNumber = target
                setTarget()
            }
        }
            
        else {
            wrong()
        }
    }
    
    func setTarget() {
        target = mode.newTarget(self)
        setTitle("\(NSLocalizedString("Target", comment: "target")): \(target)")
    }
    
    func setTitle(target: String) {
        let currentController = currentViewController()
        currentController?.levelLabel.text = "\(currentController!.getLevelLabel())\n\(target)"
    }
    
    func cheater () {
        startTimer?.invalidate()
        switchTimer?.invalidate()
        
        if let currentController = self.currentViewController() {
            currentController.view.userInteractionEnabled = false
            currentController.backButtonPressed(UIButton())
        }
    }
    
    func wrong () {
        dispatch_async(dispatch_get_main_queue()) {
            self.switchTimer?.invalidate()
            
            let currentController = self.currentViewController()!
            currentController.view.userInteractionEnabled = false
            
            for var i = 0; i < self.buttons.count; i++ {
                self.buttons[i].enabled = false
                self.buttons[i].backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8)
                self.buttons[i].setTitle("\(self.buttons[i].tag)", forState: UIControlState.Normal)
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
                    nextViewController.tSwitches = currentController.tSwitches
                    nextViewController.fSwitches = currentController.fSwitches
                    nextViewController.mode = currentController.mode
                    currentController.navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
        }
    }
    
    func nextLevel () {
        let currentController = self.currentViewController()!
        currentController.view.userInteractionEnabled = false
        if currentController.level > 0 {
            if currentController.level == level {
                level!++
                saveAndEncryptUserDefaults("l", hash: "lH", item: "\(level)")
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
