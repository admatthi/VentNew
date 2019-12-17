
//
//  DiscoverViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 10/27/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import AudioToolbox
import AVFoundation

var wishlistids = [String]()
var selectedgenre = String()
var genres = [String]()
var counter = Int()
var musictimer : Timer?
var updater : CADisplayLink?
var player : AVPlayer?
var referrer = String()
var selectedauthorimage = String()
var uid = String()
var ref : DatabaseReference?

var bookindex = Int()
               var selectedauthor = String()
               var selectedtitle = String()
               var selectedurl = String()
               var selectedbookid = String()
               var selectedamazonurl = String()
               var selecteddescription = String()
               var selectedduration = Int()
        

class DiscoverViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var counter = 0
        //
        var books: [Book] = [] {
            didSet {

                self.titleCollectionView.reloadData()

            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        
        textone = ""
        texttwo = ""
        textthree = ""

    }

        @IBOutlet var searchField: UITextField!

        @IBOutlet weak var tapback: UIButton!
        @IBOutlet weak var tapbuton: UIButton!
        @IBAction func tapBack(_ sender: Any) {

            titleCollectionView.alpha = 0

            if counter > 1 {

                tapbuton.alpha = 1
                counter -= 1


                tapgenre.text = genres[counter]
                selectedgenre = genres[counter]
      

                queryforids { () -> Void in


                }

                tapbuton.alpha = 0.25

            } else {

                counter -= 1


                tapgenre.text = genres[counter]
                selectedgenre = genres[counter]
      
                queryforids { () -> Void in


                }

                tapback.alpha = 0

            }

        }
    
    func queryforinfo() {
                
        ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if let purchased = value?["Purchased"] as? String {
                
                if purchased == "True" {
                    
                    didpurchase = true
                    
                } else {
                                 
                    didpurchase = false
                    self.performSegue(withIdentifier: "HomeToSale", sender: self)
                    
                }
                
            } else {
                
                didpurchase = false
              self.performSegue(withIdentifier: "HomeToSale", sender: self)
            }
     
        })
        
    }

        @IBAction func tapGenre(_ sender: Any) {

            titleCollectionView.alpha = 0

            if counter < genres.count-1 {

                tapbuton.alpha = 0.25


                tapgenre.text = genres[counter]
                selectedgenre = genres[counter]
  
                queryforids { () -> Void in

                }

                tapback.alpha = 0.25

            } else {

                tapbuton.alpha = 0

            }
        }
        @IBOutlet weak var tapgenre: UILabel!
        @IBOutlet weak var tapselectedgenre: UIButton!
        @IBOutlet weak var titleCollectionView: UICollectionView!

        @IBOutlet weak var scrollView: UIScrollView!

        var swipecounter = Int()

        let swipeRightRec = UISwipeGestureRecognizer()
        let swipeLeftRec = UISwipeGestureRecognizer()
        let swipeUpRec = UISwipeGestureRecognizer()
        let swipeDownRec = UISwipeGestureRecognizer()

        func textFieldDidBeginEditing(_ textField: UITextField) {

            titleCollectionView.isUserInteractionEnabled = false

        }

        @objc func swipeR() {

            swipecounter += 1
            selectedindex = swipecounter

            genreCollectionView.reloadData()

        }

        @objc func swipeL() {

            swipecounter -= 1
            selectedindex = swipecounter
            genreCollectionView.reloadData()

        }

        var intdayofweek = Int()

       

        @IBOutlet var darklabel: UILabel!

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            print(searchField.text!)

            darklabel.alpha = 0
            titleCollectionView.isUserInteractionEnabled = true

            if searchField.text != "" {

                text = searchField.text!

                self.view.endEditing(true)

           

                queryforsearch()

            } else {

            }

            return true
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            self.view.endEditing(true)

            titleCollectionView.isUserInteractionEnabled = true

        }

        @objc func loadList(notification: NSNotification) {

            self.titleCollectionView.reloadData()

        }

        var mycolors = [UIColor]()

    @IBOutlet weak var backimage: UIImageView!
    override func viewDidLoad() {
            super.viewDidLoad()

            ref = Database.database().reference()

            queryforinfo()
            
        genres.removeAll()
//        genres.append("Work")
//        genres.append("Parents")
//        genres.append("Girls")
//        genres.append("Friends")
//        genres.append("Weight")
//        genres.append("Mental Health")
        
        // most common traumatic events
//        genres.append("Death")
//        genres.append("Divorce")
//        genres.append("Work")
//        genres.append("Money")
//        genres.append("Moving")
//        genres.append("Sick")
//        genres.append("Injured")

        
                // reflectly
        
//            genres.append("Work")
//            genres.append("Family")
//            genres.append("Relationship")
//            genres.append("School")
//            genres.append("Food")
//            genres.append("Travel")
//            genres.append("Friends")
//            genres.append("Religion")
//            genres.append("Education")

                // common MH conditions and stressors, job interviews
                
                    genres.append("Sleep")
                    genres.append("Depression")
                    genres.append("Insecurity")
                    genres.append("Panic")
                    genres.append("Anxiety")
                    genres.append("Nervous")
                    genres.append("Grieving")
                    genres.append("Addiction")
                    genres.append("Anger")
              



            


            selectedgenre = "Sleep"
        
            let date = Date()
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "MMM d"
              let result = dateFormatter.string(from: date)

              dateformat = result

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backimage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       backimage.addSubview(blurEffectView)

            NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)

         


            if selectedgenre == "" || selectedgenre == "None" {

                selectedgenre = "Money"

                selectedindex = genres.firstIndex(of: selectedgenre)!

                genreCollectionView.reloadData()

            } else {

                print(selectedindex)

                selectedindex = genres.firstIndex(of: selectedgenre)!

                genreCollectionView.reloadData()

            }

            titleCollectionView.reloadData()

            //        addstaticbooks()



            //        dayofmonth = "15"

            musictimer?.invalidate()
            
            updater?.invalidate()
            player?.pause()

            var screenSize = titleCollectionView.bounds
            var screenWidth = screenSize.width
            var screenHeight = screenSize.height

            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2.3, height: screenWidth/1.7)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

            titleCollectionView!.collectionViewLayout = layout

            queryforids { () -> Void in

            }

            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.view.addGestureRecognizer(swipeLeft)

            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)

            counter = 0


            // Do any additional setup after loading the view.
        }

        @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

            if let swipeGesture = gesture as? UISwipeGestureRecognizer {

                switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.right:

                    if selectedindex > 0 {

                        selectedindex = selectedindex - 1

                        selectedgenre = genres[selectedindex]

                        

                        queryforids { () -> Void in

                        }

                        genreCollectionView.reloadData()

                    }

                case UISwipeGestureRecognizer.Direction.down:
                    break
                case UISwipeGestureRecognizer.Direction.left:

                    if selectedindex < 3 {

                        selectedindex = selectedindex + 1

                        selectedgenre = genres[selectedindex]


                        queryforids { () -> Void in

                        }


                        genreCollectionView.reloadData()

                    }
                case UISwipeGestureRecognizer.Direction.up:
                    break
                default:
                    break
                }
            }
        }

    
    var genreindex = Int()
        var text = String()

        func queryforsearch() {

            text = text.capitalized

            print(text)

            ref?.child("AllBooks3").child("All").queryOrdered(byChild: "Name").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in

                var value = snapshot.value as? NSDictionary

                print (value)

                if let snapDict = snapshot.value as? [String: AnyObject] {

                    let genre = Genre(withJSON: snapDict)

                    if let newbooks = genre.books {

                        self.books = newbooks

                        print(self.books)

                        self.titleCollectionView.reloadData()
                        self.selectedindex = 1000
                        referrer = "Search"
                        selectedgenre = ""

                        self.genreCollectionView.reloadData()

                    }

                } else {

                    self.books.shuffle()
                    self.titleCollectionView.reloadData()

                }

            })
        }

        func queryforids(completed: @escaping (() -> Void) ) {

            titleCollectionView.alpha = 0

            var functioncounter = 0

 

            ref?.child("AllBooks1").child(selectedgenre).observeSingleEvent(of: .value, with: { (snapshot) in

                var value = snapshot.value as? NSDictionary

                print (value)

                if let snapDict = snapshot.value as? [String: AnyObject] {

                    let genre = Genre(withJSON: snapDict)

                    if let newbooks = genre.books {

                        self.books = newbooks

                        self.books = self.books.sorted(by: { $0.popularity ?? 0  > $1.popularity ?? 0 })

                    }

    //                                for each in snapDict {
    //
    //                                    functioncounter += 1
    //
    //                                    let ids = each.key
    //
    //                                    seemoreids.append(ids)
    //
    //
    //                                    if functioncounter == snapDict.count {
    //
    //                                        self.updateaudiostructure()
    //
    //                                    }
    //                                }

                }

            })
        }

        func queryforwishlists() {

            wishlistids.removeAll()
            var functioncounter = 0

            ref?.child("Users").child(uid).child("Wishlist").observeSingleEvent(of: .value, with: { (snapshot) in

                var value = snapshot.value as? NSDictionary

                print (value)

                if let snapDict = snapshot.value as? [String: AnyObject] {

                    for each in snapDict {

                        let ids = each.key

                        wishlistids.append(ids)

                        functioncounter += 1

                        if functioncounter == snapDict.count {

                            self.titleCollectionView.reloadData()
                        }

                    }
                }
            })

        }

     

        

        var dayofmonth = String()

        func addstaticbooks() {

            selectedgenre = "Love"

            var counter2 = 7

            while counter2 < 12 {

                ref?.child("AllBooks1").child(selectedgenre).child("\(counter2)").updateChildValues(["Author": "Jordan B. Peterson", "BookID": "\(counter2)", "Description": "What does everyone in the modern world need to know? Renowned psychologist Jordan B. Peterson's answer to this most difficult of questions uniquely combines the hard-won truths of ancient tradition with the stunning revelations of cutting-edge scientific research.", "Genre": "\(selectedgenre)", "Image": "F\(counter2)", "Name": "12 Rules for Life", "Completed": "No", "Views": "x", "AmazonURL": "https://www.amazon.com/b?ie=UTF8&node=17025012011"])

                //    ref?.child("AllBooks2").child(selectedgenre).child("\(counter2)").updateChildValues([ "Views" : "\(nineviews[counter2])"])

                ref?.child("AllBooks1").child(selectedgenre).child("\(counter2)").child("Summary").child("Text").updateChildValues(["1": "x", "2": "x", "3": "x", "4": "x", "5": "x", "6": "x", "7": "x", "8": "x", "9": "x", "10": "x", "11": "x", "12": "x", "13": "x", "14": "x", "15": "x", "16": "x", "17": "x", "18": "x", "19": "x", "20": "x", "Title": "x"])

                counter2 += 1

            }

        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            refer = "On Tap Discover"

            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            self.view.endEditing(true)
            titleCollectionView.isUserInteractionEnabled = true

            if collectionView.tag == 1 {

                selectedindex = indexPath.row

                genreCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)

                collectionView.alpha = 0

                selectedgenre = genres[indexPath.row]


                genreindex = indexPath.row

                queryforids { () -> Void in

                }

    //            titleCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                

                genreCollectionView.reloadData()

            } else {

                let book = self.book(atIndexPath: indexPath)
                
                
                headlines.removeAll()
                
                bookindex = indexPath.row
                selectedauthorname = book?.author ?? ""
                selectedtitle = book?.name ?? ""
                selectedurl = book?.audioURL ?? ""
                selectedbookid = book?.bookID ?? ""
                selectedgenre = book?.genre ?? ""
                selectedamazonurl = book?.amazonURL ?? ""
                selecteddescription = book?.description ?? ""
                selectedduration = book?.duration ?? 15
                selectedheadline = book?.headline1 ?? ""
                selectedprofession = book?.profession ?? ""
                selectedauthorimage = book?.authorImage ?? ""
                selectedbackground = book?.imageURL ?? ""

                    
                headlines.append(book?.headline1 ?? "x")
                headlines.append(book?.headline2 ?? "x")
                headlines.append(book?.headline3 ?? "x")
                headlines.append(book?.headline4 ?? "x")
                headlines.append(book?.headline5 ?? "x")
                headlines.append(book?.headline6 ?? "x")
                headlines.append(book?.headline7 ?? "x")
                headlines.append(book?.headline8 ?? "x")
                
                headlines = headlines.filter{$0 != "x"}

                let alert = UIAlertController(title: "What would you like to do?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Read", style: .default, handler: { action in
                      switch action.style{
                      case .default:
                            print("default")

                        
                      case .cancel:
                            print("cancel")

                      case .destructive:
                            print("destructive")


                }}))
                alert.addAction(UIAlertAction(title: "Listen", style: .default, handler: { action in
                               switch action.style{
                               case .default:
                                     print("default")

                                     self.performSegue(withIdentifier: "HomeToListen", sender: self)
                               case .cancel:
                                     print("cancel")

                               case .destructive:
                                     print("destructive")


                         }}))
                
                
                    self.performSegue(withIdentifier: "HomeToRead", sender: self)

             
            }


        }

        private var contentOffset: CGPoint?

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

        }

        func organizebyalphabetical() {

            titleCollectionView.reloadData()

        }

        @IBOutlet weak var genreCollectionView: UICollectionView!

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            switch collectionView {
            case self.genreCollectionView:
                return genres.count
            case self.titleCollectionView:
                return books.count
            default:
                return 0
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            switch collectionView {
            // Genre collection
            case self.genreCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath) as! GenreCollectionViewCell

                collectionView.alpha = 1
                cell.titlelabel.text = genres[indexPath.row]
                //            cell.titlelabel.sizeToFit()

                cell.selectedimage.layer.cornerRadius = 10.0
                cell.selectedimage.layer.masksToBounds = true
                
             
                

                genreCollectionView.alpha = 1

                if selectedindex == 0 {

                    if indexPath.row == 0 {

                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1

                    } else {

                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0

                    }
                }

                if selectedindex == 1 {

                    if indexPath.row == 1 {

                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1

                    } else {

                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0

                    }

                }

                if selectedindex == 2 {

                    if indexPath.row == 2 {

                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1

                    } else {

                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0

                    }

                }

                if selectedindex == 3 {

                    if indexPath.row == 3 {

                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1

                    } else {

                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0

                    }

                }

                if selectedindex == 4 {

                    if indexPath.row == 4 {

                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1

                    } else {

                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0

                    }
                }

                if selectedindex == 5 {

                    if indexPath.row == 5 {

                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1

                    } else {

                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0

                    }

                }

                if selectedindex == 6 {

                    if indexPath.row == 6 {

                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1

                    } else {

                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0

                    }

                }

                if selectedindex == 7 {

                    if indexPath.row == 7 {

                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1

                    } else {

                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0

                    }

                }
                
                if selectedindex == 8 {
                    
                    if indexPath.row == 8 {
                        
                        cell.titlelabel.alpha = 1
                        cell.selectedimage.alpha = 1
                        
                    } else {
                        
                        cell.titlelabel.alpha = 0.25
                        cell.selectedimage.alpha = 0
                        
                    }
                    
                }


                if selectedindex == 1000 {

                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                }

                return cell

            case self.titleCollectionView:
                let book = self.book(atIndexPath: indexPath)
                titleCollectionView.alpha = 1
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Books", for: indexPath) as! TitleCollectionViewCell
                //
                //            if book?.bookID == "Title" {
                //
                //                return cell
                //
                //            } else {

                
            
                let name = book?.name

                if (name?.contains(":"))! {

                    var namestring = name?.components(separatedBy: ":")

                    cell.titlelabel.text = namestring![0]

                } else {

                    cell.titlelabel.text = name

                }

//                cell.tapup.tag = indexPath.row
//
//                cell.tapup.addTarget(self, action: #selector(DiscoverViewController.tapWishlist), for: .touchUpInside)

                if let imageURLString = book?.imageURL, let imageUrl = URL(string: imageURLString) {

                    cell.titleImage.kf.setImage(with: imageUrl)



                    cell.titleImage.layer.cornerRadius = 5.0
                    cell.titleImage.clipsToBounds = true
                    cell.titleImage.alpha = 1

                  
                    
                    
//                    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
//                    blurEffectView.frame = cell.titleback.bounds
//                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                    cell.titleback.addSubview(blurEffectView)


                }

                let isWished = Bool()

                if wishlistids.contains(book!.bookID) {


                } else {

                }

                cell.layer.cornerRadius = 5.0
                cell.layer.masksToBounds = true

                cell.titlelabel.alpha = 1
                cell.titlelabel.alpha = 1

                
             

          
                return cell

                //            }

            default:

                return UICollectionViewCell()
            }

        }

        var selectedindex = Int()

        @objc func tapWishlist(sender: UIButton) {

            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

            let book = self.book(atIndex: sender.tag)
            let author = book?.author
            let name = book?.name
            let imageURL = book?.imageURL
            let bookID = book?.bookID
            let selectedduration = book?.duration ?? 15
            let amazonlink = book?.amazonURL ?? ""
            let originals = book?.original ?? "No"
            let description = book?.description

            if let index = wishlistids.index(of: bookID!) {

                wishlistids.remove(at: index)

                ref?.child("Users").child(uid).child("Wishlist").child(bookID!).removeValue()

                titleCollectionView.reloadData()

            } else {

                ref?.child("Users").child(uid).child("Wishlist").child(bookID!).updateChildValues(["Author": author, "Name": name, "Image": imageURL, "Genre": selectedgenre, "Description": description, "Duration": selectedduration, "Amazon": amazonlink, "Original" : originals])

                wishlistids.append(bookID!)

                titleCollectionView.reloadData()

      
            }

        }

        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        /*
         // MARK: - Navigation

         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */

        

    

    }

    // MARK: - Helpers
    extension DiscoverViewController {
        func book(atIndex index: Int) -> Book? {
            if index > books.count - 1 {
                return nil
            }

            return books[index]
        }

        func book(atIndexPath indexPath: IndexPath) -> Book? {
            return self.book(atIndex: indexPath.row)
        }
    }

    //var selectedurl = String()

  
    var mostrecentlyselectedbook: Book?

    extension UILabel {

        func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

            guard let labelText = self.text else { return }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.lineHeightMultiple = lineHeightMultiple

            let attributedString: NSMutableAttributedString
            if let labelattributedText = self.attributedText {
                attributedString = NSMutableAttributedString(attributedString: labelattributedText)
            } else {
                attributedString = NSMutableAttributedString(string: labelText)
            }

            // (Swift 4.2 and above) Line spacing attribute
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

            // (Swift 4.1 and 4.0) Line spacing attribute
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

            self.attributedText = attributedString
        }
    }
