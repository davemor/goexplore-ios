//
//  LogEntry.swift
//  Go Explore
//
//  Created by David Morrison on 04/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import MapKit

class LogEntry {
    let id: Int
    let wildlifeId: Int
    let location: CLLocationCoordinate2D
    let date: NSDate
    let weather: String
    let image: UIImage
    
    func dataAsString() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(date)
    }
    
    func dataAsStringForUI() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.stringFromDate(date)
    }
    
    func locationAsStringForUI() -> String {
        let lat = String(format: "%.8f", location.latitude)
        let lng = String(format: "%.8f", location.longitude)
        return "\(lat), \(lng)"
    }
    
    init (  id: Int,
            wildlifeId: Int,
            location: CLLocationCoordinate2D,
            date: NSDate,
            weather: String,
            image: UIImage) {
        self.id = id
        self.wildlifeId = wildlifeId
        self.location = location
        self.date = date
        self.weather = weather
        self.image = image
    }
}
