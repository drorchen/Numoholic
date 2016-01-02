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
        case 1:
            game.setTitle(NSLocalizedString("ASC", comment: "Ascending"))
            
        case 2:
            game.setTitle(NSLocalizedString("RAND", comment: "Random"))
            
        case 3:
            game.setTitle(NSLocalizedString("DESC", comment: "Descending"))
            
        default:
            game.setTitle(NSLocalizedString("ASC", comment: "Ascending"))
        }
        
        return 0
    }
    
    func newTarget (game: Game) -> Int {
        switch mode {
        case 1:
            if game.target == 0 {
                game.setTitle(NSLocalizedString("ASC", comment: "Ascending"))
                return 1
            }
            
            return game.target+1
        
        case 2:
            game.setTitle(NSLocalizedString("RAND", comment: "Random"))
            return randomTarget(game)
            
        case 3:
            if game.target == 0 {
                return game.buttons.count
            }
            
            return game.target-1
            
        default:
            return 1
        }
    }
    
    func randomTarget (game: Game) -> Int {
        let target = Int(arc4random_uniform(UInt32(game.grid.x*game.grid.y)))+1
        
        var found = false
        for var i = 0; i < game.buttons.count; i++ {
            if target == game.buttons[i].tag {
                found = true
            }
        }
        
        if found {
            let currentController = game.currentViewController()
            currentController?.levelLabel.text = "\(currentController!.getLevelLabel()), \(NSLocalizedString("Target", comment: "target")): \(target)"
            return target
        }
            
        else {
            return randomTarget(game)
        }
    }
    
}
