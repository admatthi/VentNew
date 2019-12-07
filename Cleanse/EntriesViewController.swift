//
//  EntriesViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 11/6/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase

class EntriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var books: [Book] = [] {
        didSet {
            
            self.collectionView.reloadData()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        queryforids { () -> Void in
                  
              }
    }
    
    @IBOutlet weak var backi: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backi.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backi.addSubview(blurEffectView)
        
        queryforids { () -> Void in
            
        }
        
            var screenSize = collectionView.bounds
            var screenWidth = screenSize.width
            var screenHeight = screenSize.height

            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2.3, height: screenWidth/1.7)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

            collectionView!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
    func queryforids(completed: @escaping (() -> Void) ) {
        
        
        
        
        
        ref?.child("Entries").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            print (value)
            
            if let snapDict = snapshot.value as? [String: AnyObject] {
                
                let genre = Genre(withJSON: snapDict)
                
                if let newbooks = genre.books {
                    
                    self.books = newbooks
                    
                    self.books = self.books.sorted(by: { $0.popularity ?? 0  > $1.popularity ?? 0 })
                    
                }
                
            }
            
        })
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
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
        textone = book?.text1 ?? ""
        texttwo = book?.text2 ?? ""
        textthree = book?.text3 ?? ""
        
        headlines.append(book?.headline1 ?? "x")
        headlines.append(book?.headline2 ?? "x")
        headlines.append(book?.headline3 ?? "x")
        headlines.append(book?.headline4 ?? "x")
        headlines.append(book?.headline5 ?? "x")
        headlines.append(book?.headline6 ?? "x")
        headlines.append(book?.headline7 ?? "x")
        headlines.append(book?.headline8 ?? "x")
        
        headlines = headlines.filter{$0 != "x"}

        
        self.performSegue(withIdentifier: "EntrieToRead", sender: self)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return books.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let book = self.book(atIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Books", for: indexPath) as! TitleCollectionViewCell
        
        let name = book?.name

            
        cell.titlelabel.text = name
            
        
        if let date3 = book?.date {
            
            
            cell.datelabel.text = date3
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
        
    }
    
    
    
}

extension EntriesViewController {
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

var textone = String()
var texttwo = String()
var textthree = String()

