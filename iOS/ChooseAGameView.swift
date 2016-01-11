//
//  GameView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/6/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class ChooseAGameView: NumViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentChooseAGameView = self
        
        if level > maxLevel {
            levelButton.setTitle("\(NSLocalizedString("Level", comment: "Level")) \(level) \(NSLocalizedString("coming_soon", comment: "coming soon"))", forState: UIControlState.Normal)
            levelButton.enabled = false
        }
            
        else {
            levelButton.setTitle("\(NSLocalizedString("Level", comment: "Level")) \(level)", forState: UIControlState.Normal)
        }
        
        styleTheBackButton(backButton)
        styleAButton(levelButton)
        styleAButton(chooseButton)
        styleAButton(generateButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if level > maxLevel {
            levelButton.setTitle("\(NSLocalizedString("Level", comment: "Level")) \(level) \(NSLocalizedString("coming_soon", comment: "coming soon"))", forState: UIControlState.Normal)
            levelButton.enabled = false
        }
            
        else {
            levelButton.setTitle("\(NSLocalizedString("Level", comment: "Level")) \(level)", forState: UIControlState.Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func levelButtonPreseed(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as! GameView
        nextViewController.level = level
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func chooseButtonPressed(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ChooseView") as! ChooseView
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func generateButtonPressed(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GenerateView") as! GenerateView
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
