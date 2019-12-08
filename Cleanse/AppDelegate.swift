//
//  AppDelegate.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 10/26/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseDatabase
import FirebaseStorage
import Purchases
import FBSDKCoreKit

var entereddiscount = String()

var actualdiscount = String()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var purchases: Purchases?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        AppEvents.activateApp()

        refer = "On Open"
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarBuyer : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "HomeTab") as! UITabBarController
        
        uid = UIDevice.current.identifierForVendor?.uuidString ?? "x"


        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarBuyer
        
        self.window?.makeKeyAndVisible()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
          
          if launchedBefore {
              
              tabBarBuyer.selectedIndex = 1
              
          } else {
              
              tabBarBuyer.selectedIndex = 0
              
              UserDefaults.standard.set(true, forKey: "launchedBefore")
              
          }
        
        queryforpaywall()
        return true
    }
    
    func queryforpaywall() {
                
        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
     
            
            if let slimey = value?["Slimey"] as? String {

                slimeybool = true
                
            } else {
                
                slimeybool = false

            }
            
            if let discountcode = value?["DiscountCode"] as? String {
                
               actualdiscount = discountcode
                
            } else {
                
                
            }
        })
        
    }
    
    

    // MARK: UISceneSession Lifecycle
    weak var purchasesdelegate: SnippetsPurchasesDelegate?




}

protocol SnippetsPurchasesDelegate: AnyObject {

    func purchaseCompleted(product: String)

}

extension AppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, completedTransaction transaction: SKPaymentTransaction, withUpdatedInfo purchaserInfo: PurchaserInfo) {

        self.purchasesdelegate?.purchaseCompleted(product: transaction.payment.productIdentifier)

    ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
        
        didpurchase = true
 

    }

    func purchases(_ purchases: Purchases, receivedUpdatedPurchaserInfo purchaserInfo: PurchaserInfo) {
        print(purchaserInfo)

    }

    func purchases(_ purchases: Purchases, failedToUpdatePurchaserInfoWithError error: Error) {
        print(error)

    }

    func purchases(_ purchases: Purchases, failedTransaction transaction: SKPaymentTransaction, withReason failureReason: Error) {
        print(failureReason)

    }

    func purchases(_ purchases: Purchases, restoredTransactionsWith purchaserInfo: PurchaserInfo) {
        
        ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
        
        didpurchase = true
    }

    func purchases(_ purchases: Purchases, failedToRestoreTransactionsWithError error: Error) {
        print(error)
    }
}




