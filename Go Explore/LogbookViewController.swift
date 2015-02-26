//
//  LogbookViewController.swift
//  Go Explore
//
//  Created by David Morrison on 05/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class LogbooViewController  : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "LogbookCell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.sharedInstance.logEntriesTable.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath:indexPath) as LogbookCell
        
        let wildlifeId = Array(DataManager.sharedInstance.logEntriesTable.keys)[indexPath.row]
        let wl = DataManager.sharedInstance.wildlifeTable[wildlifeId]!
        
        cell.image.image = UIImage(named: wl.imageName)
        cell.label.text = wl.name.capitalizedString
        cell.wl = wl
        cell.badge.text = toString(DataManager.sharedInstance.logEntriesTable[wildlifeId]!.count)
        cell.badge.layer.cornerRadius = 21
        cell.badge.clipsToBounds = true
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            
            let width = collectionView.frame.width / 2 - 15
            return CGSize(width: width, height: 170)
    }
    
    // set the margins
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let wl = wildlifeList[indexPath.row]
        //println("clicked on \(wl.name)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as LogBookDetailTableViewController
        let cell = sender as LogbookCell
        dest.wildlifeId = cell.wl?.id
    }
}