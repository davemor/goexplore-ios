//
//  Area.swift
//  Go Explore
//
//  Created by David Morrison on 30/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit
import SQLite

struct Area {
    let id: Int
    let name: String
    var routeIds: [Int]
    
    func color() -> UIColor {
        let colorIdx = id % Area.areaColors.count
        return Area.areaColors[colorIdx]
    }
    
    // static loader from database
    static let idCol = Expression<Int>("_id")
    static let nameCol = Expression<String>("name")
    static func fromRow(row:Row) -> Area {
        let id = row[idCol]
        let name = row[nameCol]
        return Area(id: id, name: name, routeIds: [])
    }
    
    static func color(id:Int) -> UIColor {
        let index = id < 0 ? 0 : id
        let colorIdx = index % Area.areaColors.count
        return Area.areaColors[colorIdx]
    }
    
    // static utility
    static let areaColors = [
        UIColor(rgba: "#FFF933"),
        UIColor(rgba: "#6E308B"),
        UIColor(rgba: "#DB6A28"),
        UIColor(rgba: "#98CEE6"),
        UIColor(rgba: "#007070"),
        UIColor(rgba: "#BA2036"),
        UIColor(rgba: "#00BBC9"),
        UIColor(rgba: "#666666"),
        UIColor(rgba: "#62A647"),
        UIColor(rgba: "#D386B2"),
        UIColor(rgba: "#4577B4"),
        UIColor(rgba: "#DD8566"),
        UIColor(rgba: "#342B8E"),
        UIColor(rgba: "#F9AC00"),
        UIColor(rgba: "#90268A"),
        UIColor(rgba: "#770000"),
        UIColor(rgba: "#B4D300"),
        UIColor(rgba: "#441700"),
        UIColor(rgba: "#00A455")
    ]
}