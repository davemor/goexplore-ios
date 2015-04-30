//
//  RoutesTableViewController.swift
//  Go Explore
//
//  Created by David Morrison on 31/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit
import SQLite

class RoutesTableViewController: UITableViewController, RouteListSectionHeaderViewDelegate {
    
    // table view control
    let SectionHeaderViewIdentifier = "SectionHeaderViewIdentifier"
    let defaultRowHeight:CGFloat = 64.0
    let headerHeight:CGFloat = 48.0
    var openSectionIndex:Int = NSNotFound
    var sectionInfoArray: [SectionInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // set the heights of the view
        self.tableView.sectionHeaderHeight = headerHeight
        self.openSectionIndex = NSNotFound;
        
        // register the nib for the header
        self.tableView.registerNib(UINib(nibName: "SectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderViewIdentifier)
        
        if self.sectionInfoArray.count != self.numberOfSectionsInTableView(self.tableView) {
            for area in DataManager.sharedInstance.areas {
                var sectionInfo = SectionInfo(area: area)
                sectionInfo.rowHeights = [CGFloat](count: area.routeIds.count, repeatedValue: defaultRowHeight)
                sectionInfoArray.append(sectionInfo)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.sectionInfoArray.count != self.numberOfSectionsInTableView(self.tableView) {
            for area in DataManager.sharedInstance.areas {
                var sectionInfo = SectionInfo(area: area)
                sectionInfo.rowHeights = [CGFloat](count: area.routeIds.count, repeatedValue: defaultRowHeight)
                sectionInfoArray.append(sectionInfo)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailViewController = segue.destinationViewController as! RouteDetailsViewController
        let indexPath = sender as! NSIndexPath
        let area = DataManager.sharedInstance.areas[indexPath.section]
        let route = DataManager.sharedInstance.routes[area.routeIds[indexPath.row]]
        
        detailViewController.route = route
        detailViewController.area = area
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return DataManager.sharedInstance.areas.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let sectionInfo = sectionInfoArray[section]
        return sectionInfo.open ? DataManager.sharedInstance.areas[section].routeIds.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteListCellIdentifier", forIndexPath: indexPath) as! RouteCellView
        
        // Configure the cell...
        let routeId = DataManager.sharedInstance.areas[indexPath.section].routeIds[indexPath.row]
        let route = DataManager.sharedInstance.routes[routeId]
        let area = DataManager.sharedInstance.areas[indexPath.section]
        let areaColor = area.color()
        
        cell.name.text = route!.description
        cell.length.text = toString(route!.length)
        cell.routeNumber.text = toString(route!.routeNumber)
        cell.routeNumber.textColor = areaColor
        cell.circleView.color = areaColor
        cell.circleView.setNeedsDisplay()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SectionHeaderViewIdentifier) as! SectionHeaderView
        
        // set the section info
        sectionInfoArray[section].sectionHeaderView = sectionHeaderView
        
        // completely reset the sectionHeaderView
        let isOpen = sectionInfoArray[section].open
        sectionInfoArray[section].sectionHeaderView?.setOpen(isOpen)
        
        // bind the view
        sectionHeaderView.headerLabel.text = sectionInfoArray[section].area.name // areas[section].name
        sectionHeaderView.section = section
        sectionHeaderView.delegate = self
        sectionHeaderView.colorBar.backgroundColor = sectionInfoArray[section].area.color()
        
        return sectionHeaderView;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionInfo = sectionInfoArray[indexPath.section]
        return sectionInfo.rowHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("RouteDetailSegue", sender: indexPath)
    }
    
    // MARK: - RouteListSectionHeaderViewDelegate
    
    func sectionOpened(sectionHeaderView: SectionHeaderView, section: Int) {
        
        // mark this section as open
        var sectionInfo = sectionInfoArray[section]
        sectionInfo.open = true
        
        // index paths for rows to insert
        var indexPathsToInsert:[NSIndexPath] = []
        for index in 0..<sectionInfo.area.routeIds.count {
            var indexPath = NSIndexPath(forRow: index, inSection: section)
            indexPathsToInsert.append(indexPath)
        }
        
        // index paths for rows to delete, if any
        
        var indexPathsToDelete:[NSIndexPath] = []
        let previousOpenSectionIndex = openSectionIndex
        if previousOpenSectionIndex != NSNotFound {
            var previousOpenSection = sectionInfoArray[previousOpenSectionIndex]
            previousOpenSection.open = false
            previousOpenSection.sectionHeaderView?.toggleOpenWithUserAction(false)
            for index in 0..<previousOpenSection.area.routeIds.count {
                var indexPath = NSIndexPath(forRow: index, inSection: previousOpenSectionIndex)
                indexPathsToDelete.append(indexPath)
            }
        }
        
        // create some animations so it's smooth
        var insertAnimation:UITableViewRowAnimation
        var deleteAnimation:UITableViewRowAnimation
        if (previousOpenSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
            insertAnimation = UITableViewRowAnimation.Top
            deleteAnimation = UITableViewRowAnimation.Bottom
        } else {
            insertAnimation = UITableViewRowAnimation.Bottom
            deleteAnimation = UITableViewRowAnimation.Top
        }
        
        // apply updates with animations
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(indexPathsToInsert, withRowAnimation:insertAnimation)
        tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation:deleteAnimation)
        tableView.endUpdates()
        
        // set the current open section
        openSectionIndex = section;
    }
    
    func sectionClosed(sectionHeaderView: SectionHeaderView, section: Int) {
        
        // make the section as closed
        var sectionInfo = sectionInfoArray[section]
        sectionInfo.open = false
        
        let numRowsToDelete = tableView.numberOfRowsInSection(section)
        if numRowsToDelete > 0 {
            var indexPathsToDelete:[NSIndexPath] = []
            for index in 0..<numRowsToDelete {
                var indexPath = NSIndexPath(forRow: index, inSection: section)
                indexPathsToDelete.append(indexPath)
            }
            tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: UITableViewRowAnimation.Top)
        }
        
        // set the current open section to empty
        openSectionIndex = NSNotFound;
    }
}
