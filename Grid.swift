//
//  Grid.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class Grid: NSObject {
    var grid: [[Int]]!
    var x: Int
    var y: Int
    
    init (x: Int, y: Int) {
        self.x = x
        self.y = y
        super.init()
    }
    
    convenience init (grid: [[Int]], x: Int, y: Int) {
        self.init(x: x, y: y)
        self.grid = grid
    }
    
    func generateGridLocation () -> [Int] {
        let xGrid = Int(arc4random_uniform(UInt32(x)))
        let yGrid = Int(arc4random_uniform(UInt32(y)))
        
        if (grid.contains { $0 == [xGrid,yGrid] }) {
            return generateGridLocation()
        }
        
        else {
            return [xGrid, yGrid]
        }
    }
    
    func createGrid () -> [[Int]] {
        grid = []
        
        while grid.count != x*y {
            grid.append(generateGridLocation())
        }
        
        return grid
    }
    
    func createGridView (view: UIView, label: UILabel) -> UIView {
        let gridView = UIView (frame: CGRectMake(5, label.frame.maxY+50, view.frame.width-10, view.frame.height-label.frame.maxY-100))
        
        view.addSubview(gridView)
        return gridView
    }
    
    func addButtonsToGridView (gridView: UIView) -> [UIButton] {
        let width = gridView.frame.width / CGFloat(x)
        let height = gridView.frame.height / CGFloat(y)
        
        var buttons = [UIButton]()
        
        for var i = 0; i < grid.count; i++ {
            let button = UIButton(type: UIButtonType.System)
            button.frame = CGRectMake(CGFloat(grid[i][0])*width+3+(width-6)/2, CGFloat(grid[i][1])*height+3+(height-6)/2, 0, 0)
            button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
            button.layer.cornerRadius = min((width-6),(height-6))/8
            button.setTitle("\(i+1)", forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont.systemFontOfSize(min((width-6),(height-6))/2.41911764705882)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.titleLabel!.adjustsFontSizeToFitWidth = true
            button.titleLabel!.baselineAdjustment = .AlignCenters
            button.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
            gridView.addSubview(button)
            buttons.append(button)
            
            UIView.animateWithDuration(0.4, animations: {
                button.frame = CGRectMake(CGFloat(self.grid[i][0])*width+3, CGFloat(self.grid[i][1])*height+3, width-6, height-6)
            })
        }
        
        return buttons
    }
}
