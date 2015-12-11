//
//  ViewController.swift
//  Numoholic
//
//  Created by Dror Chen on 12/6/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
var level: Int! = NSUserDefaults.standardUserDefaults().objectForKey("level") as! Int!
var currentChooseAGameView: ChooseAGameView!
var maxLevel = 65

class ViewController: NumViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if level == nil {
            NSUserDefaults.standardUserDefaults().setObject(1, forKey: "level")
            NSUserDefaults.standardUserDefaults().synchronize()
            level = 1
        }
        
        playButton.layer.cornerRadius = 10
        playButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14)
        howToPlayButton.layer.cornerRadius = 10
        howToPlayButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14)
        settingsButton.layer.cornerRadius = 10
        settingsButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14)
        
    }
    
    func backButtonPressed (sender: AnyObject) {
        
    }
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        if level == 1 {
            howToPlayButtonPressed(sender)
        }
        
        else {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ChooseAGameView") as! ChooseAGameView
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @IBAction func howToPlayButtonPressed(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TutorialView") as! TutorialView
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SettingsView") as! SettingsView
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

