//
//  TextHomeViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 1/3/20.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase

class TextHomeViewController: UIViewController, UITextViewDelegate {

     @IBOutlet weak var textView: UITextView!
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var bookcover: UIImageView!
        @IBOutlet weak var authorlabel: UILabel!
        @IBOutlet weak var titlelabel: UILabel!
        
        func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

            textView.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            textView.resignFirstResponder()
        }
        
        @IBAction func tapBack(_ sender: Any) {
            
            lastcount()
            
        }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.textView.endEditing(true)
        
        
        
    }
        
        var arrayCount = Int()
        
        @IBOutlet weak var headline: UILabel!
        @IBOutlet weak var text: UILabel!
        
        func nextcount() {
            
            textView.text = ""
              textView.textColor = UIColor.white
            
            if counter > headlines.count-2 {
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                
                

                
                self.dismiss(animated: true, completion: nil)
                
                self.progressView.setProgress(0.0, animated: true)

                
                viewDidLoad()
                
            } else {
                
                counter += 1
                
                
                
                showpropersummaries()
    //            textView.slideInFromRight()
    //            text.slideInFromRight()
            }
            
        }
    //
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //         if(text == "\n") {
    //             textView.resignFirstResponder()
    //             return false
    //         }
    //         return true
    //     }

         /* Older versions of Swift */
    //     func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    //         if(text == "\n") {
    //             textView.resignFirstResponder()
    //             return false
    //         }
    //         return true
    //     }
        
        @IBAction func tapDismiss(_ sender: Any) {
            
            self.dismiss(animated: true, completion: nil)
        }
        @IBOutlet weak var authorftile: UILabel!
        @IBOutlet weak var titleoftile: UILabel!
        
        @IBOutlet weak var backimage: UIImageView!
    
    func queryforinfo() {
                
        ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if let purchased = value?["Purchased"] as? String {
                
                if purchased == "True" {
                    
                    didpurchase = true
                    
                } else {
                                 
                    didpurchase = false
                    self.performSegue(withIdentifier: "HomeToSale2", sender: self)
                    
                }
                
            } else {
                
                didpurchase = false
              self.performSegue(withIdentifier: "HomeToSale2", sender: self)
            }
     
        })
        
    }
    @IBOutlet weak var dayofweeklabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backimage.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backimage.addSubview(blurEffectView)
        
        ref = Database.database().reference()
        
//        progressView.layer.borderColor = UIColor.white.cgColor
//        progressView.layer.borderWidth = 0.2
        headlines.removeAll()
        queryforinfo()
        
        let date = Date()
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "MMM d"
        var result = dateFormatter.string(from: date)

                       dateformat = result
        
        datelabel.text = dateformat
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        result = dateFormatter.string(from: date)
        var weekday = (Date().dayOfWeek()!)
     
            
        dayofweeklabel.text = String(weekday)
            
   
        selectedgenre = "Chill"
        selectedtitle = "Morning Vent"
        selectedauthor = "Vent"
        dateFormatter.dateFormat = "HH"
        time = dateFormatter.string(from: NSDate() as Date)
        
        //        addstaticbooks()
        
        
        
        //        dayofmonth = "15"
        
        
        
        randomString = NSUUID().uuidString

        
        counter = 0
        
        
        counter = 0
        setDoneOnKeyboard()
        //        textView.returnKeyType = UIReturnKeyType.done
        
  
        
        textView.layer.cornerRadius = 5.0
        textView.clipsToBounds = true
        
    
        textView.text = "•  What was traumatic about today?"
        textView.textColor = UIColor.lightGray
        
        

        
        headlines.append("What is the one goal you're focused on this week?")
        headlines.append("What are three things you can do today to reach your weekly goal?")
        headlines.append("What are three things you are grateful for this morning?")


  
        let imageURLString = selectedbackground
        
        let  imageUrl = URL(string: imageURLString)
        
//        authorftile.text = selectedauthorname
//
        newText = textView.text
        
        selectedbookid = result
        
        //        if newText.count < 240 {
        //
        //                 tapsave.alpha = 0.5
        //                 tapsave.isUserInteractionEnabled = false
        //            characterslabel.alpha = 1
        //             } else {
        //
        //                 tapsave.alpha = 1
        //                 tapsave.isUserInteractionEnabled = true
        //                characterslabel.alpha = 0
        //             }
        //
        
        // Do any additional setup after loading the view.
    }
    
    
        
    @IBOutlet weak var datelabel: UILabel!
    func lastcount() {

             if counter == 0 {

                self.dismiss(animated: true, completion: nil)
                
             } else {

                 counter -= 1
                showpropersummaries()
    //
    //             textView.slideInFromLeft()
    //             text.slideInFromLeft()

             }


         }
        
        override func viewDidDisappear(_ animated: Bool) {
            
                textone = ""
                texttwo = ""
                textthree = ""
        }
        
        func showpropersummaries() {

            if counter == 0 {

                self.progressView.setProgress(0.0, animated: false)

            } else {
                let progress = (Float(counter)/Float(arrayCount-1))
                self.progressView.setProgress(Float(progress), animated: true)
            }

            if counter < headlines.count {
                
                if counter == 0 {
                    
                    if textone != "" {
                        
                        textView.text = textone
                    } else {
                        
                        textView.text = ""

                    }
                }
                
                if counter == 1 {
                    
                    if texttwo != "" {
                        
                        textView.text = texttwo
                    } else {
                        
                        textView.text = ""

                    }
                }
                
                if counter == 2 {
                    
                    if textthree != "" {
                        
                        textView.text = textthree
                    } else {
                        
                        textView.text = ""

                    }
                }

            text.text = headlines[counter]


            print(counter)

            }
        }
        
        @IBOutlet weak var characterslabel: UILabel!
        @IBOutlet weak var progressView: UIProgressView!
    
        
        var newText = String()
        
        func textViewDidChange(_ textView: UITextView) {
            
    //        newText = textView.text
    //
    //        let myint = 240-newText.count
    //
    //        characterslabel.text = "\(myint)"
    //
    //        if newText.count < 240 {
    //
    //            tapsave.alpha = 0.5
    //            tapsave.isUserInteractionEnabled = false
    //            characterslabel.alpha = 1
    //        } else {
    //
    //            tapsave.alpha = 1
    //            tapsave.isUserInteractionEnabled = true
    //            characterslabel.alpha = 0
    //        }
        }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "•  What was traumatic about today?"{
            textView.text = "•  "
            textView.textColor = UIColor.white
        } else {
            
            var allstring = textView.text!
            
            if allstring.contains("•  What else happened today?") {
                
                allstring = allstring.replacingOccurrences(of: "•  What else happened today?", with: "•  ")
                
                textView.textColor = UIColor.white

                textView.text = allstring

                
            }
        }
    }
        
        func setDoneOnKeyboard() {
            let keyboardToolbar = UIToolbar()
            keyboardToolbar.sizeToFit()
            let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(TextViewController.dismissKeyboard))
            keyboardToolbar.items = [flexBarButton, doneBarButton]
            self.textView.inputAccessoryView = keyboardToolbar
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
        
        @IBOutlet weak var tapsave: UIButton!
        @IBAction func tapContinue(_ sender: Any) {
            
            if textView.text != "" {
                
                if headlines.count == 1 {
                    
                    ref?.child("Entries").child(uid).child(selectedbookid).removeValue()
                    
                    ref?.child("Entries").child(uid).childByAutoId().updateChildValues(["Author" : "Morning Vent", "Name" : selectedtitle, "Headline1" : headlines[0], "Author Image" : "nil", "Image" : "https://firebasestorage.googleapis.com/v0/b/cleanse-recipes.appspot.com/o/Background%20Copy%403x.png?alt=media&token=f18959f4-ef74-41d1-b72b-749107ae14bb", "Text\(counter)" : textView.text!, "Date" : dateformat])
                    
                }
                
                if headlines.count == 2 {
                    
                    ref?.child("Entries").child(uid).child(selectedbookid).removeValue()
                    
                    ref?.child("Entries").child(uid).childByAutoId().updateChildValues(["Author" : "Morning Vent", "Name" : selectedtitle, "Headline1" : headlines[1], "Author Image" : "nil", "Image" : "https://firebasestorage.googleapis.com/v0/b/cleanse-recipes.appspot.com/o/Background%20Copy%403x.png?alt=media&token=f18959f4-ef74-41d1-b72b-749107ae14bb", "Text\(counter)" : textView.text!, "Date" : dateformat])

                }
                
                
                if headlines.count == 3 {
                    
                    
                    
                    ref?.child("Entries").child(uid).child(randomString).updateChildValues(["Author" : "Morning Vent", "Name" : selectedtitle, "Headline1" : headlines[0], "Headline2" : headlines[1], "Headline3" : headlines[2], "Author Image" : "nil", "Image" : "https://firebasestorage.googleapis.com/v0/b/cleanse-recipes.appspot.com/o/Background%20Copy%403x.png?alt=media&token=f18959f4-ef74-41d1-b72b-749107ae14bb", "Text\(counter)" : textView.text!, "Date" : dateformat])
                    
                }
                
                if headlines.count == 4 {
                    
                    
                    
                    ref?.child("Entries").child(uid).child(randomString).updateChildValues(["Author" : selectedauthorname, "Name" : selectedtitle, "Headline1" : headlines[0], "Headline2" : headlines[1], "Headline3" : headlines[2],"Headline4" : headlines[3], "Author Image" : "nil", "Image" : "https://firebasestorage.googleapis.com/v0/b/cleanse-recipes.appspot.com/o/Background%20Copy%403x.png?alt=media&token=f18959f4-ef74-41d1-b72b-749107ae14bb", "Text\(counter)" : textView.text!, "Date" : dateformat])
                    
                }
                
                if headlines.count == 5 {
                    
                    
                    
                    ref?.child("Entries").child(uid).child(randomString).updateChildValues(["Author" : selectedauthorname, "Name" : selectedtitle, "Headline1" : headlines[0], "Headline2" : headlines[1], "Headline3" : headlines[2],"Headline4" : headlines[3],"Headline5" : headlines[4], "Author Image" : "nil", "Image" : "https://firebasestorage.googleapis.com/v0/b/cleanse-recipes.appspot.com/o/Background%20Copy%403x.png?alt=media&token=f18959f4-ef74-41d1-b72b-749107ae14bb", "Text\(counter)" : textView.text!, "Date" : dateformat])

                }
                
                if headlines.count == 6 {
                    
                    
                    
                    ref?.child("Entries").child(uid).child(randomString).updateChildValues(["Author" : selectedauthorname, "Name" : selectedtitle, "Headline1" : headlines[0], "Headline2" : headlines[1], "Headline3" : headlines[2],"Headline4" : headlines[3],"Headline5" : headlines[4],"Headline6" : headlines[5], "Author Image" : selectedauthorimage, "Image" : selectedbackground, "Text\(counter)" : textView.text!, "Date" : dateformat])

                }
                
                if headlines.count == 7 {
                    
                    
                    
                    ref?.child("Entries").child(uid).child(randomString).updateChildValues(["Author" : selectedauthorname, "Name" : selectedtitle, "Headline1" : headlines[0], "Headline2" : headlines[1], "Headline3" : headlines[2],"Headline4" : headlines[3],"Headline5" : headlines[4],"Headline6" : headlines[5],"Headline7" : headlines[6], "Author Image" : selectedauthorimage, "Image" : selectedbackground, "Text\(counter)" : textView.text!, "Date" : dateformat])

                }
                
                if headlines.count == 8 {
                    
                    
                    
                    ref?.child("Entries").child(uid).child(randomString).updateChildValues(["Author" : selectedauthorname, "Name" : selectedtitle, "Headline1" : headlines[0], "Headline2" : headlines[1], "Headline3" : headlines[2],"Headline4" : headlines[3],"Headline5" : headlines[4],"Headline6" : headlines[5],"Headline7" : headlines[6],"Headline8" : headlines[7], "Author Image" : selectedauthorimage, "Image" : selectedbackground, "Text\(counter)" : textView.text!, "Date" : dateformat])

                }
                
                nextcount()
                
            } else {
                
                nextcount()
                
            }
            
        }
        

        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "•  " || textView.text.isEmpty {
                textView.text = "•  What was traumatic about today?"
                textView.textColor = UIColor.lightGray
            } else {
            
                ref?.child("Entries").child(uid).child(monthdate).removeValue()
            
            ref?.child("Entries").child(uid).child(monthdate).updateChildValues(["Author" : "Morning Vent", "Name" : monthdate, "Headline1" : headlines[0], "Author Image" : "nil", "Image" : "https://firebasestorage.googleapis.com/v0/b/cleanse-recipes.appspot.com/o/Background%20Copy%403x.png?alt=media&token=f18959f4-ef74-41d1-b72b-749107ae14bb", "Text0" : textView.text!, "Date" : dayweek])
                
                oldtext = textView.text!
                
                var myMutableString = NSMutableAttributedString()
                
                myMutableString = NSMutableAttributedString(string: "\(oldtext)\n\n•  What else happened today?", attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Medium", size: 19.0)!])
                
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:oldtext.count))

                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location:oldtext.count,length:30))

                textView.attributedText = myMutableString
                
            }
        }
        
var oldtext = String()
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

    }

extension Date {
    func dayOfWeek() -> String? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "EEEE"
         return dateFormatter.string(from: self).capitalized
         // or use capitalized(with: locale) if you want
     }
}
