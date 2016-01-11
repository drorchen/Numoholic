//
//  TutorialView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/8/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit
import AVFoundation

class TutorialView: NumViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var howToPlayLabel: UILabel!
    var number: Int!
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        number = 1
        
        styleTheBackButton(backButton)
        styleHeaderLabel(howToPlayLabel)
        oneButton.layer.cornerRadius = oneButton.frame.width/4
        twoButton.layer.cornerRadius = twoButton.frame.width/4
        threeButton.layer.cornerRadius = threeButton.frame.width/4
        fourButton.layer.cornerRadius = fourButton.frame.width/4
        tutorialText.text = "\(NSLocalizedString("tutorial", comment: "tutorial")) \(NSLocalizedString("Target", comment: "target")): 1"
        tutorialText.layoutIfNeeded()
        self.view.layoutIfNeeded()
        tutorialText.textAlignment = NSTextAlignment.Center
        tutorialText.font = UIFont.systemFontOfSize(self.view.frame.width/20)
        tutorialText.adjustsFontSizeToFitWidth = false
        tutorialText.baselineAdjustment = UIBaselineAdjustment.AlignCenters
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func oneButtonPressed(sender: AnyObject) {
        if number == 1 {
            number!++
            
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: successClickSound)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            }
            catch {
                print(error)
            }
            
            oneButton.alpha = 0
            oneButton.enabled = false
            twoButton.enabled = true
            tutorialText.text = "\(NSLocalizedString("tutorial", comment: "tutorial")) \(NSLocalizedString("Target", comment: "target")): 2"
        }
    }
    
    @IBAction func twoButtonPressed(sender: AnyObject) {
        if number == 2 {
            number!++
            
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: successClickSound)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            }
            catch {
                print(error)
            }
            
            twoButton.alpha = 0
            twoButton.enabled = false
            threeButton.enabled = true
            tutorialText.text = "\(NSLocalizedString("tutorial", comment: "tutorial")) \(NSLocalizedString("Target", comment: "target")): 3"
        }
    }
    
    @IBAction func threeButtonPressed(sender: AnyObject) {
        if number == 3 {
            number!++
            
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: successClickSound)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            }
            catch {
                print(error)
            }
            
            threeButton.alpha = 0
            threeButton.enabled = false
            fourButton.enabled = true
            tutorialText.text = "\(NSLocalizedString("tutorial", comment: "tutorial")) \(NSLocalizedString("Target", comment: "target")): 4"
        }
    }
    
    @IBAction func fourButtonPressed(sender: AnyObject) {
        if number == 4 {
            number!++
            
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: successClickSound)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            }
            catch {
                print(error)
            }
            
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
