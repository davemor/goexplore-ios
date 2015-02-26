//
//  LogDetailTableViewCell.swift
//  Go Explore
//
//  Created by David Morrison on 05/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class LogDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    var logEntry: LogEntry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
