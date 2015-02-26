//
//  SectionHeaderView.swift
//  Go Explore
//
//  Created by David Morrison on 31/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var colorBar: UIView!
    
    
    var delegate: RouteListSectionHeaderViewDelegate?
    var section:Int?
    var isOpen = false
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override func awakeFromNib() {
        // set up a background color
        let bgView = UIView(frame: self.bounds)
        bgView.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 255)
        self.backgroundView = bgView
        
        // set up the tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "toggleOpen")
        self.addGestureRecognizer(tapGesture)
    }
    
    func toggleOpen() {
        toggleOpenWithUserAction(true)
    }
    
    func toggleOpenWithUserAction(userAction: Bool) {
        
        // toggle the disclosure button state
        isOpen = !isOpen
        
        // if this was a user action, send the delegate the appropriate message
        if (userAction) {
            if (isOpen) {
                delegate?.sectionOpened(self, section: section!)
            }
            else {
                delegate?.sectionClosed(self, section: section!)
            }
        }
    }
    
    func setOpen(isOpen:Bool) {
        self.isOpen = isOpen
    }
}

protocol RouteListSectionHeaderViewDelegate {
    func sectionOpened(sectionHeaderView: SectionHeaderView, section: Int)
    func sectionClosed(sectionHeaderView: SectionHeaderView, section: Int)
}

