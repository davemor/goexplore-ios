//
//  RouteBadgeView.swift
//  Go Explore
//
//  Created by David Morrison on 04/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class RouteBadgeView: UIView {
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setRoutes(routes: [(route: Int, area: Int)], vc: WildlifeDetailViewController) {

        let numDisplayedRoutes = min(routes.count-1, 4)
        addRowOfButtons(routes[0...numDisplayedRoutes], yPos: Float(self.frame.midY), vc: vc)
        
    }
    
    func addRowOfButtons(subRoutes: Slice<(route: Int, area: Int)>, yPos: Float, vc: WildlifeDetailViewController) {

        
        let buttonWidth: Float = 48.0
        let margin: Float = 10.0
        let barWidth = Float(subRoutes.count) * (buttonWidth + margin) - margin
        let startX = Float(self.frame.midX) - barWidth / 2.0
        var currX = startX
      
        // TODO: There are to many magic numbers here, revise
        let containerView = UIView(frame: CGRectMake(24.0, 0.0, 256.0, 256.0))

        for route in subRoutes {
            
            let color = getAreaColor(route.area)
            let rect = CGRect(x: Int(currX), y: 40, width: 48, height: 48)
            
            var button = UIButton(frame: rect)
            button.layer.cornerRadius = 24
            button.layer.masksToBounds = true
            button.backgroundColor = color
            button.setTitle("\(route.route)", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.tag = route.route
            button.addTarget(vc, action: "onRouteBadgePressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            containerView.addSubview(button)
        
            currX += buttonWidth + margin
        }
        
        self.addSubview(containerView)
    }
}

let areaColors: [UIColor] = [
    UIColor(red:0.58,   green:0.141, blue:0.675,    alpha:1.0),
    UIColor(red:0.051,  green:0.639, blue:0.592,    alpha:1.0),
    UIColor(red:0.639,  green:0.459, blue:0.369,    alpha:1.0),
    UIColor(red:0.004,  green:0.565, blue:1.0,      alpha:1.0),
    UIColor(red:0.894,  green:0.012, blue:0.012,    alpha:1.0),
    UIColor(red:0.475,  green:0.475, blue:0.475,    alpha:1.0),
    UIColor(red:0.0,    green:0.635, blue:0.333,    alpha:1.0),
    UIColor(red:0.808,  green:0.176, blue:0.757,    alpha:1.0),
    UIColor(red:0.051,  green:0.071, blue:0.635,    alpha:1.0),
    UIColor(red:0.988,  green:0.573, blue:0.204,    alpha:1.0),
    UIColor(red:0.275,  green:0.055, blue:0.639,    alpha:1.0),
    UIColor(red:0.631,  green:0.914, blue:0.141,    alpha:1.0),
    UIColor(red:0.608,  green:0.0,   blue:0.0,      alpha:1.0),
    UIColor(red:0.059,  green:0.635, blue:0.631,    alpha:1.0),
    UIColor(red:1.0,    green:0.333, blue:0.0,      alpha:1)
]

func getAreaColor(areaId: Int) -> UIColor {
    return areaColors[areaId % areaColors.count]
}