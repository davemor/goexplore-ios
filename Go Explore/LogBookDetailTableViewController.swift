//
//  LogBookDetailTableViewController.swift
//  Go Explore
//
//  Created by David Morrison on 05/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class LogBookDetailTableViewController: UITableViewController {

    let ReuseIdentifier = "LogbookDetailTableCell"
    let HeaderReuseIdentifier = "LogbookDetailReuseId"
    var wildlifeId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerNib(UINib(nibName: "LogbookDetailHeader", bundle: nil), forCellReuseIdentifier: "LogbookDetailReuseId")
        
        let wildlifeName = DataManager.sharedInstance.wildlifeTable[wildlifeId!]?.name
        self.navigationItem.title = wildlifeName?.capitalized
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let logs = DataManager.sharedInstance.logEntriesTable[wildlifeId!] {
            return logs.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier, forIndexPath: indexPath) as LogDetailTableViewCell

        if let logs = DataManager.sharedInstance.logEntriesTable[wildlifeId!] {
            let log = logs[indexPath.row]
            cell.title.text = log.dataAsStringForUI()
            // cell.thumbnail.image = log.image
            cell.logEntry = log
        }

        return cell
    }
    
    // headers
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerOpt: AnyObject? = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderReuseIdentifier)
        if headerOpt == nil {
            headerOpt = NSBundle.mainBundle().loadNibNamed("LogbookDetailHeader", owner: self, options: nil)[0]
        }
        let header = headerOpt as LogbookDetailHeaderView
        let imageName = DataManager.sharedInstance.wildlifeTable[wildlifeId!]?.imageName
        header.image.image = UIImage(named: imageName!)
        return header
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowLogEntryDetails" {
            let cell = sender as LogDetailTableViewCell
            let dest = segue.destinationViewController as LogEntryDetailViewController
            dest.logEntry = cell.logEntry
            
        }
    }
}















