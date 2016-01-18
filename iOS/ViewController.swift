//
//  ViewController.swift
//  Numoholic
//
//  Created by Dror Chen on 12/6/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit
import AVFoundation

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
var level: Int! = getLevel()
var removedAds: Bool! = getRemovedAds()
var currentChooseAGameView: ChooseAGameView!
var maxLevel = 95
var player = AVAudioPlayer()
var musicOn: Bool!
var soundEffectsOn: Bool! = getSoundEffects()
var audioPlayer: AVAudioPlayer!
let successClickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("successClick", ofType: "mp3")!)
let wrongClickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wrongClick", ofType: "mp3")!)
//let guiClickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("guiClick", ofType: "mp3")!)
let guiClickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wrongClick", ofType: "mp3")!)

func playASound (sound: NSURL) {
    if soundEffectsOn! {
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch {
            print(error)
        }
    }
}

func prepareSound (sound: NSURL) {
    do {
        audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        audioPlayer.prepareToPlay()
    }
    catch {
        print(error)
    }
}

class ViewController: NumViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if level == nil {
            saveAndEncryptUserDefaults("l", hash: "lH", item: "\(1)")
            level = 1
        }
        
        styleAButton(playButton)
        styleAButton(howToPlayButton)
        styleAButton(settingsButton)
        
        prepareSound(guiClickSound)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func backButtonPressed (sender: AnyObject) {
        
    }
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        if level == 1 {
            howToPlayButtonPressed(sender)
        }
        
        else {
            playASound(guiClickSound)
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ChooseAGameView") as! ChooseAGameView
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @IBAction func howToPlayButtonPressed(sender: AnyObject) {
        playASound(guiClickSound)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TutorialView") as! TutorialView
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        playASound(guiClickSound)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SettingsView") as! SettingsView
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

