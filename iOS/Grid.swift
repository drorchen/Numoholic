//
//  Grid.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class Grid: NSObject {
    var grid: [Position]!
    var x: Int
    var y: Int
    
    init (x: Int, y: Int) {
        self.x = x
        self.y = y
        super.init()
    }
    
    convenience init (grid: [Position], x: Int, y: Int) {
        self.init(x: x, y: y)
        self.grid = grid
    }
    
    func generateAllPossiblePositions () -> [Position] {
        var possiblePositions = [Position]()
        
        for var i = 0; i < x; i++ {
            for var j = 0; j < y; j++ {
                possiblePositions.append(Position(x: i, y: j))
            }
        }
        
        return possiblePositions
    }
    
    func createGrid () -> [Position] {
        grid = []
        var allPossiblePositions = generateAllPossiblePositions()
        
        while grid.count != x*y {
            let randNum = Int(arc4random_uniform(UInt32(allPossiblePositions.count)))
            grid.append(allPossiblePositions[randNum])
            allPossiblePositions = allPossiblePositions.filter() { $0 !== allPossiblePositions[randNum] }
        }
        
        return grid
    }
    
    func createGridView (view: UIView, label: UILabel) -> UIView {
        let gridView = UIView (frame: CGRectMake(5, label.frame.maxY+70, view.frame.width-10, view.frame.height-label.frame.maxY-130))
        
        view.addSubview(gridView)
        return gridView
    }
    
    func addButtonsToGridView (gridView: UIView, spacingTargets: Bool) -> [UIButton] {
        let width = gridView.frame.width / CGFloat(x)
        let height = gridView.frame.height / CGFloat(y)
        let space = gridView.frame.width/121.666666666667
        
        var buttons = [UIButton]()
        
        for var i = 0; i < grid.count; i++ {
            let button = UIButton(type: UIButtonType.System)
            button.frame = CGRectMake(CGFloat(grid[i].x)*width+space+(width-2*space)/2, CGFloat(grid[i].y)*height+space+(height-2*space)/2, 0, 0)
            button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
            button.layer.cornerRadius = min((width-2*space),(height-2*space))/8
            button.setTitle("\(buttonTitle(spacingTargets, buttons: buttons))", forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont.systemFontOfSize(min((width-2*space),(height-2*space))/2.41911764705882)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.titleLabel!.adjustsFontSizeToFitWidth = true
            button.titleLabel!.baselineAdjustment = .AlignCenters
            button.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
            gridView.addSubview(button)
            buttons.append(button)
            
            UIView.animateWithDuration(0.4, animations: {
                button.frame = CGRectMake(CGFloat(self.grid[i].x)*width+space, CGFloat(self.grid[i].y)*height+space, width-2*space, height-2*space)
            })
        }
        
        return buttons
    }
    
    func buttonTitle (random: Bool, buttons: [UIButton]) -> Int {
        if !random {
            return buttons.count+1
        }
        
        let num = Int(arc4random_uniform(UInt32(grid.count*10)))+1
        let checkIfExist = buttons.filter() { $0.titleLabel!.text == "\(num)" }
        
        if checkIfExist.count == 0 {
            return num
        }
        
        return buttonTitle(true, buttons: buttons)
    }
}
