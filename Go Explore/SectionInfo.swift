//
//  SectionInfo.swift
//  ExpandingTableViewTest
//
//  Created by David Morrison on 31/01/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class SectionInfo {
    var sectionHeaderView: SectionHeaderView?
    let area: Area
    
    var open = false
    var rowHeights:[CGFloat] = []
    
    init(area: Area) {
        self.area = area
    }
}