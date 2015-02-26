//
//  LogEntryDetailViewController.swift
//  Go Explore
//
//  Created by David Morrison on 05/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class LogEntryDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var logEntry: LogEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // bind the views
        image.image = logEntry?.image
        dateTimeLabel.text = logEntry?.dataAsStringForUI()
        weatherLabel.text = logEntry?.weather
        locationLabel.text = logEntry?.locationAsStringForUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func deleteLogEntry(sender: UIButton) {
        DataManager.sharedInstance.deleteLogEntry(logEntry!)
        navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
