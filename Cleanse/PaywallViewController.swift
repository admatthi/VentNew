//
//  PaywallViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 10/27/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import Purchases
import FBSDKCoreKit
var refer = String()


@objc protocol SwiftPaywallDelegate {
    func purchaseCompleted(paywall: PaywallViewController, transaction: SKPaymentTransaction, purchaserInfo: Purchases.PurchaserInfo)
    @objc optional func purchaseFailed(paywall: PaywallViewController, purchaserInfo: Purchases.PurchaserInfo?, error: Error, userCancelled: Bool)
    @objc optional func purchaseRestored(paywall: PaywallViewController, purchaserInfo: Purchases.PurchaserInfo?, error: Error?)
}

class PaywallViewController: UIViewController {
    
    
    var delegate : SwiftPaywallDelegate?
    
    @IBOutlet weak var termstext: UILabel!
    @IBOutlet weak var disclaimertext: UIButton!
    @IBOutlet weak var leadingtext: UILabel!
    
    
    @IBAction func tapRestore(_ sender: Any) {
        
        
    }
    
    @IBAction func tapBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var backimage: UIImageView!
    
    
    
    @IBAction func tapContinue(_ sender: Any) {
        
        logTapSubscribeEvent(referrer : refer)
        
        guard let package = offering?.availablePackages[0] else {
            print("No available package")
            return
        }
        
        Purchases.shared.purchasePackage(package) { (trans, info, error, cancelled) in
            
            if let error = error {
                if let purchaseFailedHandler = self.delegate?.purchaseFailed {
                    purchaseFailedHandler(self, info, error, cancelled)
                } else {
                    if !cancelled {
                        
                    }
                }
            } else  {
                if let purchaseCompletedHandler = self.delegate?.purchaseCompleted {
                    purchaseCompletedHandler(self, trans!, info!)
                    
                    self.logPurchaseSuccessEvent(referrer : refer)
                    //
                    ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
                    
                    didpurchase = true
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    
                    self.logPurchaseSuccessEvent(referrer : refer)
                    //
                    ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
                    
                    didpurchase = true
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
        
        
        //
        //        purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
        //            if purchaserInfo?.entitlements.all["subscriptions"]?.isActive == true {
        //
        //                self.logPurchaseSuccessEvent(referrer : refer)
        //
        //                                 ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
        //
        //                                 didpurchase = true
        //                                 self.dismiss(animated: true, completion: nil)
        //
        //                // Unlock that great "pro" content
        //            }
        //        }
        //
        
        
        
    }
    
    @IBAction func tapTerms(_ sender: Any) {
        
        if let url = NSURL(string: "https://getchillapp.weebly.com/privacy"
            ) {
            UIApplication.shared.openURL(url as URL)
        }
        
    }
    
    private var offering : Purchases.Offering?
    
    private var offeringId : String?
    
    @IBOutlet weak var tapcontinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backimage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backimage.addSubview(blurEffectView)
        
        tapcontinue.layer.cornerRadius = 5.0
        
        tapcontinue.clipsToBounds = true
        
        logPaywallShownEvent(referrer : refer)
        
        queryforpaywall()
        
        Purchases.shared.offerings { (offerings, error) in
            
            if error != nil {
            }
            if let offeringId = self.offeringId {
                
                self.offering = offerings?.offering(identifier: offeringId)
            } else {
                self.offering = offerings?.current
            }
            
        }
        
    }
    
    
    
    func queryforpaywall() {
        
        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            
            
            if let slimey = value?["Slimey"] as? String {
                
                slimeybool = true
                
                self.termstext.alpha = 0
                self.leadingtext.alpha = 0
                self.disclaimertext.alpha = 0
                self.tapcontinue.setTitle("Try for Free", for: .normal)
                
            } else {
                
                slimeybool = false
                self.termstext.alpha = 1
                self.leadingtext.alpha = 1
                self.disclaimertext.alpha = 1
                self.tapcontinue.setTitle("Continue", for: .normal)
                
            }
            
            if let discountcode = value?["DiscountCode"] as? String {
                
                actualdiscount = discountcode
                
            } else {
                
                
            }
        })
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func logPaywallShownEvent(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "paywall shown"), parameters: ["referrer" : referrer])
    }
    
    func logTapSubscribeEvent(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "tap subscribe"), parameters: ["referrer" : referrer])
    }
    
    func logPurchaseSuccessEvent(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "purchase success"), parameters: ["referrer" : referrer])
    }
    
}
