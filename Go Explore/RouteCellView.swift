//
//  RouteCellView.swift
//  Go Explore
//
//  Created by David Morrison on 31/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class RouteCellView : UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var routeNumber: UILabel!
    @IBOutlet weak var circleView: RouteBadgeForListView!
}