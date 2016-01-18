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
}
