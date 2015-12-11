//
//  NumViewController.swift
//  Numoholic
//
//  Created by Dror Chen on 12/8/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class NumViewController: UIViewController {
    
    override func viewDidLoad() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "backButtonPressed:")
        if #available(iOS 9.0, *) {
            if NSLocale.characterDirectionForLanguage(NSLocale.preferredLanguages()[0]).rawValue == 2 {
                swipeRight.direction = UISwipeGestureRecognizerDirection.Left
            }
                
            else {
                swipeRight.direction = UISwipeGestureRecognizerDirection.Right
            }
        }
        
        else {
            swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        }
        self.view.addGestureRecognizer(swipeRight)
        self.view.userInteractionEnabled = true
        self.view.exclusiveTouch = true
    }
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false
        }
        else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait ,UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
