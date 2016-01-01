//
//  SettingsView.swift
//  Numoholic
//
//  Created by Dror Chen on 12/8/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit
import StoreKit

class SettingsView: NumViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, UIActionSheetDelegate {
    var productIDs: Array<String!> = []
    var productsArray: Array<SKProduct!> = []
    var selectedProductIndex: Int!
    var transactionInProgress = false
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetLevelsButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var removeAdsButton: UIButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!
    @IBOutlet weak var temporaryConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeAdsButton.setTitle("Loading...", forState: UIControlState.Normal)
        restorePurchasesButton.setTitle("Loading...", forState: UIControlState.Normal)
        removeAdsButton.enabled = false
        restorePurchasesButton.enabled = false
        
        if removedAds! {
            temporaryConstraint.constant = -removeAdsButton.frame.height
            removeAdsButton.hidden = true
            restorePurchasesButton.hidden = true
            removeAdsButton.setTitle("", forState: UIControlState.Normal)
            restorePurchasesButton.setTitle("", forState: UIControlState.Normal)
        }
        
        else {
            productIDs.append("numoholic.removeAdsInApp")
            requestProductInfo()
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        }
        
        styleTheBackButton(backButton)
        styleAButton(resetLevelsButton)
        styleAButton(removeAdsButton)
        styleAButton(restorePurchasesButton)
        styleHeaderLabel(settingsLabel)
    }
    
    deinit {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: (productIdentifiers as! Set<String>))
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
            
            availableProducts()
        }
        else {
            print("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    func availableProducts () {
        for product in productsArray {
            print(product.localizedTitle)
            print(product.localizedDescription)
        }
        
        removeAdsButton.enabled = true
        restorePurchasesButton.enabled = true
        removeAdsButton.setTitle("Remove Ads", forState: UIControlState.Normal)
        restorePurchasesButton.setTitle("Restore Purchases", forState: UIControlState.Normal)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased, SKPaymentTransactionState.Restored:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                saveAndEncryptUserDefaults("a", hash: "aH", item: "true")
                removedAds = true
                break
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed");
                
                if #available(iOS 8.0, *) {
                    let alert = UIAlertController(title: "", message: "Transaction Failed", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let doneAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    }
                    
                    alert.addAction(doneAction)
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
                    
                else {
                    let alert = UIAlertView()
                    alert.delegate = view
                    alert.title = ""
                    alert.message = "Transaction Failed"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
                
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                break
                
            default:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                print(transaction.transactionState.rawValue)
                break
            }
        }
    }
    
    @IBAction func removeAdsButtonPressed(sender: AnyObject) {
        selectedProductIndex = 0
        
        if transactionInProgress {
            return
        }
        
        if #available(iOS 8.0, *) {
            let actionSheetController = UIAlertController(title: NSLocalizedString("Ads_removal", comment: "Ads removal"), message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let buyAction = UIAlertAction(title: NSLocalizedString("Buy", comment: "Buy"), style: UIAlertActionStyle.Default) { (action) -> Void in
                let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as SKProduct)
                SKPaymentQueue.defaultQueue().addPayment(payment)
                self.transactionInProgress = true
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIAlertActionStyle.Cancel) { (action) -> Void in
                
            }
            
            actionSheetController.addAction(buyAction)
            actionSheetController.addAction(cancelAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                actionSheetController.popoverPresentationController!.sourceView = self.view
                actionSheetController.popoverPresentationController!.sourceRect = sender.frame
                actionSheetController.view.layoutIfNeeded()
            }
            
            presentViewController(actionSheetController, animated: true, completion: nil)
        }
            
        else {
            let alert = UIActionSheet()
            alert.delegate = self
            alert.title = NSLocalizedString("Ads_removal", comment: "Ads removal")
            alert.addButtonWithTitle(NSLocalizedString("Buy", comment: "Buy"))
            alert.addButtonWithTitle(NSLocalizedString("Cancel", comment: "Cancel"))
            alert.cancelButtonIndex = 1
            alert.showInView(self.view)
        }
    }
    
    @IBAction func restorePurchasesButtonPressed(sender: UIButton) {
        if (SKPaymentQueue.canMakePayments()) {
            sender.enabled = false
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as SKProduct)
        SKPaymentQueue.defaultQueue().addPayment(payment)
        self.transactionInProgress = true
    }
    
    @IBAction func resetLevelsButtonPressed(sender: AnyObject) {
        saveAndEncryptUserDefaults("l", hash: "lH", item: "\(1)")
        level = 1
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
