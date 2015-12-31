//
//  NumViewController.swift
//  Numoholic
//
//  Created by Dror Chen on 12/8/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit
import iAd

class NumViewController: UIViewController, ADBannerViewDelegate {
    var adBanner: ADBannerView = ADBannerView()
    
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
        
        if removedAds == nil {
            saveAndEncryptUserDefaults("a", hash: "aH", item: "false")
            removedAds = false
        }
        
        if removedAds! {
            adBanner.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let SH = UIScreen.mainScreen().bounds.height
        
        adBanner = appDelegate.adBanner
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            adBanner.frame = CGRectMake(0, SH-66, 0, 0)
        }
            
        else {
            adBanner.frame = CGRectMake(0, SH-50, 0, 0)
        }
        
        adBanner.delegate = self
        self.view.addSubview(adBanner)
        
        if removedAds! {
            adBanner.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        adBanner.removeFromSuperview()
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        UIView.animateWithDuration(1, animations: {
            self.adBanner.alpha = 1
        })
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        UIView.animateWithDuration(1, animations: {
            self.adBanner.alpha = 1
        })
    }
    
    func styleAButton (button: UIButton) {
        button.titleLabel!.textAlignment = NSTextAlignment.Center
        button.titleLabel!.font = UIFont.systemFontOfSize(self.view.frame.width/11.3636363636364)
        button.titleLabel!.adjustsFontSizeToFitWidth = false
        button.titleLabel!.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        button.layer.cornerRadius = self.view.frame.width/37.5
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14)
    }
    
    func styleTheBackButton (button: UIButton) {
        button.titleLabel!.textAlignment = NSTextAlignment.Center
        button.titleLabel!.font = UIFont.systemFontOfSize(self.view.frame.width/18.5)
        button.titleLabel!.adjustsFontSizeToFitWidth = false
        button.titleLabel!.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        button.layer.cornerRadius = self.view.frame.width/37.5
        button.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
    }
    
    func styleHeaderLabel (label: UILabel) {
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(self.view.frame.width/8.33333333333333)
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
    }
    
    func removeScrollingFromView (view: UIView) {
        for subview in view.subviews {
            self.removeScrollingFromView(subview)
        }
        
        if view.isKindOfClass(UIWebView) {
            (view as! UIWebView).scrollView.scrollEnabled = false
            (view as! UIWebView).scrollView.bounces = false
        }
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
