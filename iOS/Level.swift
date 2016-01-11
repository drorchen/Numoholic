//
//  Level.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class Level: NSObject {
    var grid: [Position]!
    var x: Int!
    var y: Int!
    var timer: CGFloat!
    var level: Int
    var switchTimes: Int
    var tSwitchTimes: Int
    var fSwitchTimes: Int
    var mode: Int
    
    init (level: Int) {
        self.level = level
        switchTimes = 0
        tSwitchTimes = 0
        fSwitchTimes = 0
        mode = 1
        super.init()
    }
    
    func createLevel (xGrid: Int, yGrid: Int, timerInt: CGFloat, switchesNum: Int, tSwitchesNum: Int, fSwitchesNum: Int, mode: Int) -> Grid {
        switch level {
        case 0:
            x = xGrid
            y = yGrid
            timer = timerInt
            switchTimes = switchesNum
            tSwitchTimes = tSwitchesNum
            fSwitchTimes = fSwitchesNum
            self.mode = mode
            
            let customGrid = Grid(x: self.x, y: self.y)
            grid = customGrid.createGrid()
            break
        
        case 1:
            // [[0,0], [0,1], [1,0], [1,1]]
            grid = [Position(x: 0, y: 0), Position(x: 0, y: 1), Position(x: 1, y: 0), Position(x: 1, y: 1)]
            x = 2
            y = 2
            timer = 1.5
            break
            
        case 2:
            grid = [Position(x: 0, y: 1), Position(x: 0, y: 0), Position(x: 1, y: 1), Position(x: 1, y: 0)]
            x = 2
            y = 2
            timer = 1.5
            break
            
        case 3:
            // [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2]]
            grid = [Position(x: 1, y: 2), Position(x: 0, y: 0), Position(x: 0, y: 2), Position(x: 1, y: 0), Position(x: 0, y: 1), Position(x: 1, y: 1)]
            x = 2
            y = 3
            timer = 1.2
            break
            
        case 4:
            grid = [Position(x: 0, y: 0), Position(x: 1, y: 2), Position(x: 1, y: 0), Position(x: 0, y: 2), Position(x: 1, y: 1), Position(x: 0, y: 1)]
            x = 2
            y = 3
            timer = 1.2
            break
            
        default:
            if level >= 5 && level <= maxLevel {
                var difLevel: Int!
                
                if level >= 5 && level <= 15 {
                    x = 2
                    y = 3
                    timer = 2.5
                    difLevel = 5
                }
                    
                else if level >= 16 && level <= 25 {
                    x = 2
                    y = 3
                    timer = 3.0
                    difLevel = 16
                    self.mode = 2
                }
                    
                else if level >= 26 && level <= 35 {
                    x = 3
                    y = 3
                    timer = 3.0
                    difLevel = 26
                }
                    
                else if level == 36 {
                    x = 3
                    y = 3
                    timer = 4.5
                    difLevel = 36
                    self.mode = 2
                }
                    
                else if level >= 37 && level <= 45 {
                    x = 3
                    y = 3
                    timer = 3.0
                    difLevel = 37
                    self.mode = 3
                }
                    
                else if level == 46 {
                    x = 3
                    y = 3
                    timer = 4.0
                    difLevel = 46
                    switchTimes = 1
                    self.mode = 2
                }
                    
                else if level >= 47 && level <= 55 {
                    x = 3
                    y = 3
                    timer = 3
                    difLevel = 47
                    
                    if level >= difLevel && level <= difLevel+5 {
                        tSwitchTimes = 1
                    }
                        
                    else if level >= difLevel+6 {
                        tSwitchTimes = 2
                    }
                }
                    
                else if level == 56 {
                    x = 3
                    y = 3
                    timer = 3.5
                    difLevel = 56
                    tSwitchTimes = 1
                    self.mode = 2
                }
                    
                else if level >= 57 && level <= 65 {
                    x = 3
                    y = 3
                    timer = 2.5
                    difLevel = 56
                    
                    if level >= difLevel && level <= difLevel+5 {
                        fSwitchTimes = 1
                    }
                        
                    else if level >= difLevel+6 {
                        fSwitchTimes = 2
                    }
                }
                    
                else if level == 66 {
                    x = 3
                    y = 3
                    timer = 3
                    difLevel = 66
                    fSwitchTimes = 1
                    self.mode = 2
                }
                    
                else if level >= 67 && level <= 75 {
                    x = 3
                    y = 3
                    timer = 3.5
                    difLevel = 66
                    tSwitchTimes = 1
                    self.mode = 4
                }
                    
                else if level == 76 {
                    x = 3
                    y = 3
                    timer = 4.0
                    difLevel = 76
                    self.mode = 5
                }
                    
                else if level >= 77 && level <= 85 {
                    x = 3
                    y = 3
                    timer = 3.0
                    difLevel = 76
                    fSwitchTimes = 1
                    self.mode = 6
                }
                    
                else if level == 86 {
                    x = 3
                    y = 3
                    timer = 4.5
                    difLevel = 76
                    switchTimes = 1
                    self.mode = 5
                }
                    
                else if level >= 87 && level <= 95 {
                    x = 4
                    y = 3
                    timer = 7.0
                    difLevel = 86
                }
                
                if level >= difLevel+4 && level <= difLevel+7 {
                    switchTimes = 1
                }
                    
                else if level >= difLevel+8 {
                    switchTimes = 2
                }
                
                timer! -= 0.1 * CGFloat((level-difLevel))
                let customGrid = Grid(x: self.x, y: self.y)
                grid = customGrid.createGrid()
            }
            break
        }
        
        return createGrid()
    }
    
    private func createGrid () -> Grid {
        return Grid (grid: self.grid, x: self.x, y: self.y)
    }
}
