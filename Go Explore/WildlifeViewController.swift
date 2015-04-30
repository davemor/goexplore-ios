//
//  WildlifeViewController.swift
//  Go Explore
//
//  Created by David Morrison on 31/12/2014.
//  Copyright (c) 2014 East Lothian Coucil. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class WildlifeViewController  : UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "WildlifeCell"
    
    var wildlifeList = DataManager.sharedInstance.wildlifeList
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return wildlifeList.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // there is only one section
        return wildlifeList.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath:indexPath) as! WildlifeCell
        let wl = wildlifeList[indexPath.row]
        
        cell.image.image = UIImage(named: wl.imageName)
        cell.label.text = wl.name.capitalizedString
        cell.wl = wl
        
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
        let wl = wildlifeList[indexPath.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! WildlifeDetailViewController
        let cell = sender as! WildlifeCell
        //dest.wildlifeId = wl.id
        dest.wildlifeOpt = cell.wl
    }
}