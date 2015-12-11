//
//  SettingsView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/8/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class SettingsView: NumViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetLevelsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 10
        backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        resetLevelsButton.layer.cornerRadius = 10
        resetLevelsButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetLevelsButtonPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(1, forKey: "level")
        NSUserDefaults.standardUserDefaults().synchronize()
        level = 1
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
