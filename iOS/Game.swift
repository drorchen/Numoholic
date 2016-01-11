//
//  Game.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit
import AVFoundation

class Game: NSObject {
    var grid: Grid!
    var gridView: UIView!
    var buttons: [UIButton]!
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
    var audioPlayer: AVAudioPlayer!
    
    
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
            button.userInteractionEnabled = true
        }
        dispatch_group_leave(switchesGroup)
    }
    
    func disableAllButtons () {
        for button in buttons {
            button.userInteractionEnabled = false
        }
        dispatch_group_leave(switchesGroup)
    }
    
    func getSwitchingVariable () -> Int {
        if fSwitchTimes > 0 {
            return 4
        }
        
        if tSwitchTimes > 0 {
            return 3
        }
        
        if switchTimes > 0 {
            return 2
        }
        
        return 0
    }
    
    func decSwitchingVariable (switchItem: Int, full: Bool) {
        switch (switchItem) {
        case 2:
            switchTimes!--
            if full {
                switchTimes = 0
            }
            
            if switchTimes == 0 {
                self.switchTimer.invalidate()
            }
            break
        case 3:
            tSwitchTimes!--
            if full {
                tSwitchTimes = 0
            }
            break
        case 4:
            fSwitchTimes!--
            if full {
                fSwitchTimes = 0
            }
            break
        default:
            break
        }
    }
    
    func switchNumTiles () {
        dispatch_group_notify(switchesGroup, dispatch_get_main_queue()) {
            let switchItem = self.getSwitchingVariable()
            if switchItem != 0 {
                if self.buttons.count >= switchItem {
                    dispatch_group_notify(self.switchesGroup, dispatch_get_main_queue()) {
                        dispatch_group_enter(self.switchesGroup)
                        self.disableAllButtons()
                    }
                    
                    dispatch_group_notify(self.switchesGroup, dispatch_get_main_queue()) {
                        dispatch_group_enter(self.switchesGroup)
                        if self.buttons.count >= switchItem {
                            let tiles = self.randomTiles(switchItem)
                            let max = tiles.maxElement()
                            
                            if max < self.buttons.count {
                                self.switchTiles(tiles, tilesNum: switchItem)
                            }
                                
                            else {
                                self.switchNumTiles()
                                dispatch_group_leave(self.switchesGroup)
                            }
                        }
                            
                        else {
                            dispatch_group_enter(self.switchesGroup)
                            self.enableAllButtons()
                            
                            self.decSwitchingVariable(switchItem, full: true)
                            
                            dispatch_group_leave(self.switchesGroup)
                        }
                    }
                }
                    
                else {
                    self.decSwitchingVariable(switchItem, full: true)
                }
            }
            
            else {
                self.switchTimer.invalidate()
            }
        }
    }
    
    func switchTiles (tiles: [Int], tilesNum: Int) {
        var framesOfTiles = [CGRect]()
        for tile in tiles {
            framesOfTiles.append(self.buttons[tile].frame)
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
                                }, completion: { (value: Bool) in
                                    dispatch_group_leave(self.switchesGroup)
                            })
                    })
            })
        }
        
        decSwitchingVariable(tilesNum, full: false)
    }
    
    func randomTiles (num: Int) -> [Int] {
        var randomTiles = [Int]()
        
        while randomTiles.count != num {
            let randNum = Int(arc4random_uniform(UInt32(buttons.count)))
            if !randomTiles.contains(randNum) {
                randomTiles.append(randNum)
            }
        }
        
        return randomTiles
    }
    
    func startTheGame () {
        let delay = 1.45 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.switchNumTiles()
            self.switchTimer = NSTimer.scheduledTimerWithTimeInterval(2.15, target: self, selector: "switchNumTiles", userInfo: nil, repeats: true)
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
        dispatch_group_notify(self.switchesGroup, dispatch_get_main_queue()) {
            dispatch_group_enter(self.switchesGroup)
            if self.target == sender.tag {
                self.buttons = self.buttons.filter() { $0 !== sender }
                sender.enabled = false
                sender.hidden = true
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOfURL: successClickSound)
                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.play()
                }
                catch {
                    print(error)
                }
                
                if self.buttons.count == 0 {
                    self.nextLevel()
                    dispatch_group_leave(self.switchesGroup)
                }
                    
                else {
                    self.currentNumber = self.target
                    self.setTarget()
                    dispatch_group_leave(self.switchesGroup)
                }
            }
                
            else {
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOfURL: wrongClickSound)
                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.play()
                }
                catch {
                    print(error)
                }
                
                self.wrong()
                dispatch_group_leave(self.switchesGroup)
            }
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
