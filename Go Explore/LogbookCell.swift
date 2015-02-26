//
//  LogbookCell.swift
//  Go Explore
//
//  Created by David Morrison on 05/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class LogbookCell : UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var badge: UILabel!
    
    var wl: WildlifeEntry?
    
}
