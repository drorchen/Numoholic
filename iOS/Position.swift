//
//  Position.swift
//  Numoholic
//
//  Created by Dror Chen on 1/11/16.
//  Copyright © 2016 Dror Chen. All rights reserved.
//

import Foundation

func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

class Position: NSObject {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
