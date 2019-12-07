//
//  HomeTabViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 11/8/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit

class HomeTabViewController: UITabBarController {

       override func viewDidLayoutSubviews() {
            

        
    //
    //        self.tabBar.frame = CGRect(origin: CGPoint(x: 0,y :40), size: CGSize(width: view.frame.width, height: 50))
            
//            self.tabBar.frame = CGRect(origin: CGPoint(x: 0,y :30), size: CGSize(width: view.frame.width, height: 50))
//            self.tabBar.layer.borderWidth = 0.0
//            self.tabBar.clipsToBounds = true
//
//    //
//            self.tabBar.backgroundColor = .clear
//
//
//
//
//    //        self.tabBar.layer.borderColor = UIColor.white.cgColor
//            self.tabBar.itemPositioning = .centered
//
//            self.tabBar.layer.borderWidth = 0.0
//            self.tabBar.layer.borderColor = UIColor.clear.cgColor
//            self.tabBar.itemSpacing = UIScreen.main.bounds.width/10

    //
      

        }
        
      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage() // add this if you want remove tabBar separator
        tabBar.barTintColor = .clear
        tabBar.backgroundColor = .black // here is your tabBar color
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
