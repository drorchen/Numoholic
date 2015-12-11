//
//  GenerateView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class GenerateView: NumViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var xGridTextField: UITextField!
    @IBOutlet weak var yGridTextField: UITextField!
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var switchesTextField: UITextField!
    @IBOutlet weak var randomSwitch: UISwitch!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tap)
        
        backButton.layer.cornerRadius = 10
        backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        playButton.layer.cornerRadius = 10
        playButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14)
        randomSwitch.layer.cornerRadius = 16
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func plusXGridPressed(sender: AnyObject) {
        if let num = Int(xGridTextField.text!) {
            xGridTextField.text = "\(num+1)"
        }
        
        else {
            xGridTextField.text = "1"
        }
    }
    
    @IBAction func minusXGridPressed(sender: AnyObject) {
        if let num = Int(xGridTextField.text!) {
            if num > 1 {
                xGridTextField.text = "\(num-1)"
            }
            
            else {
                xGridTextField.text = "1"
            }
        }
            
        else {
            xGridTextField.text = "1"
        }
    }
    
    @IBAction func plusYGridPressed(sender: AnyObject) {
        if let num = Int(yGridTextField.text!) {
            yGridTextField.text = "\(num+1)"
        }
            
        else {
            yGridTextField.text = "1"
        }
    }
    
    @IBAction func minusYGridPressed(sender: AnyObject) {
        if let num = Int(yGridTextField.text!) {
            if num > 1 {
                yGridTextField.text = "\(num-1)"
            }
                
            else {
                yGridTextField.text = "1"
            }
        }
            
        else {
            yGridTextField.text = "1"
        }
    }
    
    @IBAction func plusTimerPressed(sender: AnyObject) {
        if let num = Double(timerTextField.text!) {
            timerTextField.text = "\(num+0.1)"
        }
            
        else {
            timerTextField.text = "0.1"
        }
    }
    
    @IBAction func minusTimerPressed(sender: AnyObject) {
        if let num = Double(timerTextField.text!) {
            if num > 0.1 {
                timerTextField.text = "\(num-0.1)"
            }
                
            else {
                timerTextField.text = "0.1"
            }
        }
            
        else {
            timerTextField.text = "0.1"
        }
    }
    
    @IBAction func plusSwitchesPressed(sender: AnyObject) {
        if let num = Int(switchesTextField.text!) {
            switchesTextField.text = "\(num+1)"
        }
            
        else {
            switchesTextField.text = "1"
        }
    }
    
    @IBAction func minusSwitchesPressed(sender: AnyObject) {
        if let num = Int(switchesTextField.text!) {
            if num > 0 {
                switchesTextField.text = "\(num-1)"
            }
                
            else {
                switchesTextField.text = "0"
            }
        }
            
        else {
            switchesTextField.text = "0"
        }
    }
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        if let xGridNum = Int(xGridTextField.text!) {
            if let yGridNum = Int(yGridTextField.text!) {
                if let timerNum = Double(timerTextField.text!) {
                    if let switchesNum = Int(switchesTextField.text!) {
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as! GameView
                        nextViewController.level = 0
                        nextViewController.xGrid = xGridNum
                        nextViewController.yGrid = yGridNum
                        nextViewController.timer = CGFloat(timerNum)
                        nextViewController.switches = switchesNum
                        nextViewController.mode = randomSwitch.on ? 2 : 1
                        navigationController?.pushViewController(nextViewController, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dismissKeyboard (recognizer: UITapGestureRecognizer) {
        xGridTextField.resignFirstResponder()
        yGridTextField.resignFirstResponder()
        timerTextField.resignFirstResponder()
    }
    
}
