//
//  Mode.swift
//  Numoholic
//
//  Created by Dror Chen on 12/13/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class Mode: NSObject {
    var mode: Int
    
    init(mode: Int) {
        self.mode = mode
        super.init()
    }
    
    func setModeTitle (game: Game) -> Int {
        switch mode {
        case 1,4:
            game.setTitle(NSLocalizedString("ASC", comment: "Ascending"))
            
        case 2,5:
            game.setTitle(NSLocalizedString("RAND", comment: "Random"))
            
        case 3,6:
            game.setTitle(NSLocalizedString("DESC", comment: "Descending"))
            
        default:
            game.setTitle(NSLocalizedString("ASC", comment: "Ascending"))
        }
        
        return 0
    }
    
    func spacingTargets() -> Bool {
        if mode > 3 {
            return true
        }
        return false
    }
    
    func newTarget (game: Game) -> Int {
        switch mode {
        case 1:
            if game.target == 0 {
                return 1
            }
            
            return game.target+1
        
        case 2,5:
            return randomTarget(game)
            
        case 3:
            if game.target == 0 {
                return game.buttons.count
            }
            
            return game.target-1
            
        case 4:
            var min = Int(game.buttons[0].titleLabel!.text!)
            
            for button in game.buttons {
                if Int(button.titleLabel!.text!) < min {
                    min = Int(button.titleLabel!.text!)
                }
            }
            
            return min!
            
        case 6:
            var max = Int(game.buttons[0].titleLabel!.text!)
            
            for button in game.buttons {
                if Int(button.titleLabel!.text!) > max {
                    max = Int(button.titleLabel!.text!)
                }
            }
            
            return max!
            
        default:
            return 1
        }
    }
    
    func randomTarget (game: Game) -> Int {
        let target = game.buttons[Int(arc4random_uniform(UInt32(game.buttons.count)))].tag
        
        let currentController = game.currentViewController()
        currentController?.levelLabel.text = "\(currentController!.getLevelLabel()), \(NSLocalizedString("Target", comment: "target")): \(target)"
        return target
    }
    
}
