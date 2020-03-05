//
//  DopeTextsViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 3/4/20.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase

class DopeTextsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return books.count
        
    }
    
    var books: [Book] = [] {
        didSet {
            
            self.collectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let book = self.book(atIndexPath: indexPath)
        
        let name = book?.name


        if didpurchase {
                      
                      let activityVC = UIActivityViewController(activityItems: [name], applicationActivities: nil)
                           activityVC.popoverPresentationController?.sourceView = self.view
                           
                           self.present(activityVC, animated: true, completion: nil)
                      
                  } else {
                      
                      self.performSegue(withIdentifier: "TextToPaywall", sender: self)

                  }
              
    }
    @IBAction func tapBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let book = self.book(atIndexPath: indexPath)
        //            titleCollectionView.alpha = 1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Books", for: indexPath) as! TitleCollectionViewCell
        
        let name = book?.name
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        
        if didpurchase {
            
            cell.titlelabel.alpha = 1
            
        } else {
            
            cell.titlelabel.alpha = 0.1
        }
        
        
        if (name?.contains(":"))! {
            
            var namestring = name?.components(separatedBy: ":")
            
            cell.titlelabel.text = namestring![0]
            
        } else {
            
            cell.titlelabel.text = name
            
        }
        
        return cell
        
        //
        
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        queryforids { () -> () in
            
            
        }
        
        var screenSize = collectionView.bounds
            var screenWidth = screenSize.width
            var screenHeight = screenSize.height
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
            layout.itemSize = CGSize(width: screenWidth/2.3, height: screenWidth/1.4)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            
            collectionView!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
    func queryforids(completed: @escaping (() -> Void) ) {
        
        //                   titleCollectionView.alpha = 0
        
        var functioncounter = 0
        
        
        
        ref?.child("AllBooks1").child("Messages").child(selectedgenre).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DopeTextsViewController {
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
