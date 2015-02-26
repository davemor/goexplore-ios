//
//  Wildlife.swift
//  Go Explore
//
//  Created by David Morrison on 03/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class WildlifeEntry {
    var id: Int
    var name: String
    var imageName: String
    var desc: String
    var routes:[Int] = []
    
    init(id: Int, name: String, imageName: String, desc: String) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.desc = desc
    }
    
    func description() -> String {
        return replaceBreakTabsWithLineBreaks(self.desc)
    }
    
    func replaceBreakTabsWithLineBreaks(string:String) -> String {
        return string.stringByReplacingOccurrencesOfString(
            "<br>",
            withString: "\n",
            options: NSStringCompareOptions.LiteralSearch,
            range: nil)
    }
}
