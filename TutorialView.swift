//
//  TutorialView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/8/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class TutorialView: NumViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var tutorialText: UILabel!
    var number: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        number = 1
        
        backButton.layer.cornerRadius = 10
        backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        oneButton.layer.cornerRadius = 10
        twoButton.layer.cornerRadius = 10
        threeButton.layer.cornerRadius = 10
        fourButton.layer.cornerRadius = 10
        tutorialText.text = NSLocalizedString("tutorial", comment: "tutorial")
        tutorialText.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func oneButtonPressed(sender: AnyObject) {
        if number == 1 {
            number!++
            
            oneButton.alpha = 0
            oneButton.enabled = false
            twoButton.enabled = true
        }
    }
    
    @IBAction func twoButtonPressed(sender: AnyObject) {
        if number == 2 {
            number!++
            
            twoButton.alpha = 0
            twoButton.enabled = false
            threeButton.enabled = true
        }
    }
    
    @IBAction func threeButtonPressed(sender: AnyObject) {
        if number == 3 {
            number!++
            
            threeButton.alpha = 0
            threeButton.enabled = false
            fourButton.enabled = true
        }
    }
    
    @IBAction func fourButtonPressed(sender: AnyObject) {
        if number == 4 {
            number!++
            
            fourButton.alpha = 0
            fourButton.enabled = false
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ChooseAGameView") as! ChooseAGameView
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
