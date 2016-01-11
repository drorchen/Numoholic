//
//  GenerateView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/7/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit
import AudioToolbox

class GenerateView: NumViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var xGridTextField: UITextField!
    @IBOutlet weak var yGridTextField: UITextField!
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var switchesTextField: UITextField!
    @IBOutlet weak var tSwitchesTextField: UITextField!
    @IBOutlet weak var fSwitchesTextField: UITextField!
    @IBOutlet weak var randomTargetsSwitch: UISwitch!
    @IBOutlet weak var randomNumbersSwitch: UISwitch!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var generateLevelLabel: UILabel!
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tap)
        
        styleTheBackButton(backButton)
        styleHeaderLabel(generateLevelLabel)
        playButton.layer.cornerRadius = 10
        playButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14)
        randomTargetsSwitch.layer.cornerRadius = 16
        randomNumbersSwitch.layer.cornerRadius = 16
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
    
    @IBAction func plusTSwitchesPressed(sender: AnyObject) {
        if let num = Int(tSwitchesTextField.text!) {
            tSwitchesTextField.text = "\(num+1)"
        }
            
        else {
            tSwitchesTextField.text = "1"
        }
    }
    
    @IBAction func minusTSwitchesPressed(sender: AnyObject) {
        if let num = Int(tSwitchesTextField.text!) {
            if num > 0 {
                tSwitchesTextField.text = "\(num-1)"
            }
                
            else {
                tSwitchesTextField.text = "0"
            }
        }
            
        else {
            tSwitchesTextField.text = "0"
        }
    }
    
    @IBAction func plusFSwitchesPressed(sender: AnyObject) {
        if let num = Int(fSwitchesTextField.text!) {
            fSwitchesTextField.text = "\(num+1)"
        }
            
        else {
            fSwitchesTextField.text = "1"
        }
    }
    
    @IBAction func minusFSwitchesPressed(sender: AnyObject) {
        if let num = Int(fSwitchesTextField.text!) {
            if num > 0 {
                fSwitchesTextField.text = "\(num-1)"
            }
                
            else {
                fSwitchesTextField.text = "0"
            }
        }
            
        else {
            fSwitchesTextField.text = "0"
        }
    }
    
    @IBAction func randomTargetsSwitchPressed(sender: AnyObject) {
        if randomTargetsSwitch.on {
            UIView.animateWithDuration(0.15, animations: {
                self.modeSegmentedControl.alpha = 0
            })
        }
            
        else {
            UIView.animateWithDuration(0.15, animations: {
                self.modeSegmentedControl.alpha = 1
            })
        }
    }
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        if let xGridNum = Int(xGridTextField.text!) {
            if let yGridNum = Int(yGridTextField.text!) {
                if let timerNum = Double(timerTextField.text!) {
                    if let switchesNum = Int(switchesTextField.text!) {
                        if let tSwitchesNum = Int(tSwitchesTextField.text!) {
                            if let fSwitchesNum = Int(fSwitchesTextField.text!) {
                                if randomTargetsSwitch.on || modeSegmentedControl.selectedSegmentIndex != -1 {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as! GameView
                                    nextViewController.level = 0
                                    nextViewController.xGrid = xGridNum
                                    nextViewController.yGrid = yGridNum
                                    nextViewController.timer = CGFloat(timerNum)
                                    nextViewController.switches = switchesNum
                                    nextViewController.tSwitches = tSwitchesNum
                                    nextViewController.fSwitches = fSwitchesNum
                                    
                                    if randomNumbersSwitch.on {
                                        nextViewController.mode = randomTargetsSwitch.on ? 5 : (modeSegmentedControl.selectedSegmentIndex == 0) ? 4 : 6
                                    }
                                    
                                    else {
                                        nextViewController.mode = randomTargetsSwitch.on ? 2 : (modeSegmentedControl.selectedSegmentIndex == 0) ? 1 : 3
                                    }
                                    
                                    navigationController?.pushViewController(nextViewController, animated: true)
                                }
                            }
                        }
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
        switchesTextField.resignFirstResponder()
        tSwitchesTextField.resignFirstResponder()
        fSwitchesTextField.resignFirstResponder()
    }
    
}
