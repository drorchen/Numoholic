//
//  Level.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class Level: NSObject {
    var grid: [[Int]]!
    var x: Int!
    var y: Int!
    var timer: CGFloat!
    var level: Int
    var switchTimes: Int
    var mode: Int
    
    init (level: Int) {
        self.level = level
        switchTimes = 0
        mode = 1
        super.init()
    }
    
    func createLevel (xGrid: Int, yGrid: Int, timerInt: CGFloat, switchesNum: Int, mode: Int) -> Grid {
        switch level {
        case 0:
            x = xGrid > 6 ? 6 : xGrid
            y = yGrid > 6 ? 6 : yGrid
            timer = timer > 25 ? 25 : timerInt
            switchTimes = switchesNum
            self.mode = mode
            
            let customGrid = Grid(x: self.x, y: self.y)
            grid = customGrid.createGrid()
            break
        
        case 1:
            // [[0,0], [0,1], [1,0], [1,1]]
            grid = [[0,0],[0,1],[1,0],[1,1]]
            x = 2
            y = 2
            timer = 1.5
            break
            
        case 2:
            grid = [[0,1],[0,0],[1,1],[1,0]]
            x = 2
            y = 2
            timer = 1.5
            break
            
        case 3:
            // [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2]]
            grid = [[1,2], [0,0], [0,2], [1,0], [0,1], [1,1]]
            x = 2
            y = 3
            timer = 1.2
            self.mode = 2
            break
            
        case 4:
            grid = [[0,0], [1,2], [1,0], [0,2], [1,1], [0,1]]
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
                    
                else if level >= 36 && level <= 45 {
                    x = 3
                    y = 3
                    timer = 3.8
                    difLevel = 36
                    self.mode = 2
                }
                    
                else if level >= 46 && level <= 55 {
                    x = 4
                    y = 3
                    timer = 6
                    difLevel = 46
                }
                    
                else if level >= 56 && level <= 65 {
                    x = 4
                    y = 3
                    timer = 6.8
                    difLevel = 56
                    self.mode = 2
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
