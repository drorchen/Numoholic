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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productIDs.append("numoholic.removeAdsInApp")
        requestProductInfo()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        removeAdsButton.setTitle("Loading...", forState: UIControlState.Normal)
        removeAdsButton.enabled = false
        
        if removedAds! {
            removeAdsButton.hidden = true
        }
        
        styleTheBackButton(backButton)
        styleAButton(resetLevelsButton)
        styleAButton(removeAdsButton)
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
        removeAdsButton.setTitle("Remove Ads", forState: UIControlState.Normal)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                saveAndEncryptUserDefaults("a", hash: "aH", item: "true")
                removedAds = true
                
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed");
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                
            default:
                print(transaction.transactionState.rawValue)
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
