//
//  FavoritesViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 1/26/20.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var backimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                  let blurEffectView = UIVisualEffectView(effect: blurEffect)
                  blurEffectView.frame = backimage.bounds
                  blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                  backimage.addSubview(blurEffectView)

        // Do any additional setup after loading the view.
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
