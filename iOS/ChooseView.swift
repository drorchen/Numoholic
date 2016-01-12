//
//  ChooseView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class ChooseView: NumViewController {
    
    @IBOutlet weak var levelScrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chooseALevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        levelScrollView.frame = CGRectMake(15, levelScrollView.frame.minY, self.view.frame.width-30, levelScrollView.frame.height-55)
        levelScrollView.scrollEnabled = true
        levelScrollView.bounces = false
        levelScrollView.showsHorizontalScrollIndicator = false
        levelScrollView.showsVerticalScrollIndicator = false
        
        for var i = 1; i <= maxLevel; i++ {
            let placeInRow = ((i-1)%4)
            let row = CGFloat(floor(Double((i-1)/4)))
            let width = (levelScrollView.frame.width-55)/4
            let height = width
            
            let levelButton = UIButton(type: UIButtonType.System)
            levelButton.frame = CGRectMake(CGFloat(placeInRow)*(width+5), row*height+row*5, width, height)
            
            levelButton.titleLabel!.text = "\(i)"
            levelButton.setTitle("\(i)", forState: UIControlState.Normal)
            levelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            if i <= level {
                levelButton.layer.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor
                levelButton.addTarget(self, action: "chosenLevel:", forControlEvents: UIControlEvents.TouchUpInside)
                levelButton.tag = i
            }
            
            else {
                levelButton.layer.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
                levelButton.enabled = false
            }
            
            levelButton.titleLabel!.textAlignment = NSTextAlignment.Center
            levelButton.titleLabel!.font = UIFont.systemFontOfSize(width/2.6)
            levelButton.titleLabel!.adjustsFontSizeToFitWidth = false
            levelButton.titleLabel!.baselineAdjustment = UIBaselineAdjustment.AlignCenters
            levelButton.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
            levelButton.layer.cornerRadius = width/8
            
            levelScrollView.addSubview(levelButton)
        }
        
        let height = CGFloat(floor(Double((maxLevel-1)/4))+1)*((levelScrollView.frame.width-55)/4+5)
        
        levelScrollView.contentSize = CGSizeMake (0, height)
        
        styleTheBackButton(backButton)
        styleHeaderLabel(chooseALevelLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func chosenLevel (sender: AnyObject) {
        playASound(guiClickSound)
        let level = sender.tag
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as! GameView
        nextViewController.level = level
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
