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
import IQKeyboardManager

var entereddiscount = String()

var actualdiscount = String()

var monthdate = String()

var dayweek = String()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        AppEvents.activateApp()

        refer = "On Open"
     
//        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabBarBuyer : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "HomeTab") as! UITabBarController
//
        uid = UIDevice.current.identifierForVendor?.uuidString ?? "x"

        let date = Date()
                          let dateFormatter = DateFormatter()
                          dateFormatter.dateFormat = "MMM d"
           var result = dateFormatter.string(from: date)

                          dateformat = result
           
           monthdate = dateformat
           
           dateFormatter.dateFormat = "yyyy-MM-dd"

           result = dateFormatter.string(from: date)
           var weekday = (Date().dayOfWeek()!)
        
               
           dayweek = String(weekday)
//
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = tabBarBuyer
//
//        self.window?.makeKeyAndVisible()
//
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//          
//          if launchedBefore {
//              
//              tabBarBuyer.selectedIndex = 0
//              
//          } else {
//              
//              tabBarBuyer.selectedIndex = 0
//              
//              UserDefaults.standard.set(true, forKey: "launchedBefore")
//              
//          }
        
        queryforpaywall()
        

        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "YuMbZXigVRCOrvLStdviFvUqYzgKMTFN", appUserID: nil)
        
    
        
        
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



}






