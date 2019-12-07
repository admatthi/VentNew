//
//  FreeToPlayViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 11/8/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase

class FreeToPlayViewController: UIViewController, UITextViewDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

             self.textView.endEditing(true)
      


    }
    
    @IBOutlet weak var haedlinelabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()

        textView.delegate = self
        
        textView.text = "Write here..."
        textView.textColor = UIColor.lightGray
        haedlinelabel.alpha = 1
//         let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//         let blurEffectView = UIVisualEffectView(effect: blurEffect)
//         blurEffectView.frame = backa.bounds
//         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        backa.addSubview(blurEffectView)
        textView.becomeFirstResponder()
        
        textView.returnKeyType = UIReturnKeyType.done

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            
        } else {
            
            haedlinelabel.alpha = 1
        }
    }
    
    
    @IBOutlet weak var backa: UIImageView!
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if(text == "\n") {
             textView.resignFirstResponder()
            
            ref?.child("Entries").child(uid).childByAutoId().updateChildValues(["Author" : "Chill", "Name" : "Daily Chill", "Headline1" : " ", "Author Image" : "https://images.unsplash.com/photo-1562708736-8d9d21c00675?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", "Image" : "https://images.unsplash.com/photo-1562708736-8d9d21c00675?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", "Text\(counter)" : textView.text!, "Date" : dateformat])
                
                textView.text = nil

                haedlinelabel.alpha = 1

            
             return false
         }
        
        if text.count > 0 {
            
            haedlinelabel.alpha = 0
        }
        
         return true
     }

     /* Older versions of Swift */
     func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
         if(text == "\n") {
             textView.resignFirstResponder()
             return false
         }
         return true
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
