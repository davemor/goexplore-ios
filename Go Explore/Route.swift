//
//  Route.swift
//  Go Explore
//
//  Created by David Morrison on 29/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import Foundation
import MapKit
import SQLite

struct Route {
    var id: Int
    var routeNumber: Int
    var coordinates: [MKMapPoint]
    var mapBounds: MKMapRect
    var length: Int
    var surface: String
    var description: String
    var primaryAreaId: Int
    var wildlife: [Int] = [Int]()
    
    // deserialise from db
    static let idCol = Expression<Int>("_id")
    static let routeNumberCol = Expression<Int>("route_number")
    static let coordinatesCol = Expression<String>("coordinates")
    static let lengthCol = Expression<String>("length")
    static let surfaceCol = Expression<String>("surface")
    static let descriptionCol = Expression<String>("description")
    static let primaryAreaIdCol = Expression<String>("primary_area")
    
    static func fromRow(row: Row) -> Route {

        let id = row[idCol]
        let routeNumber = row[routeNumberCol]
        let coordinatesStr = row[coordinatesCol]
        let length = row[lengthCol].toInt()
        let surface = row[surfaceCol]
        let description = row[descriptionCol]
        let primaryAreaId = row[primaryAreaIdCol].toInt()
        
        let (coordinates, mapBounds) = parseCoordinates(coordinatesStr)
        
        return Route(id: id, routeNumber: routeNumber, coordinates: coordinates, mapBounds: mapBounds, length: length!, surface: surface, description: description, primaryAreaId: primaryAreaId!, wildlife: [])
    }
    
    /*
    static func fromArray(row: [Binding?]) -> Route {
        let id = row[0]
        let routeNumber = row[1]
        let coordinatesStr = row[2]
        let length = row[3].toInt()
        let surface = row[4]
        let description = row[5]
        let primaryAreaId = row[6].toInt()
        
        let (coordinates, mapBounds) = parseCoordinates(coordinatesStr)
        
        return Route(id: id, routeNumber: routeNumber, coordinates: coordinates, mapBounds: mapBounds, length: length!, surface: surface, description: description, primaryAreaId: primaryAreaId!)
    }
    */
    
    static func parseCoordinates(coordStr: String) -> ( [MKMapPoint], MKMapRect ) {

        let jsonData = coordStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let jsonObject:AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        var shouldInitRect = true
        var northEastPoint = MKMapPoint(x: 0.0, y: 0.0)
        var southWestPoint = MKMapPoint(x: 0.0, y: 0.0)
        var coordinates: [MKMapPoint] = []
        
        if let topArray = jsonObject as? NSArray {
            if topArray.count > 0 {
                if let coordsArray = topArray[0] as? NSArray {
                    for coord in coordsArray {
                        let lat = CLLocationDegrees(coord[1] as! Double)
                        let lng = CLLocationDegrees(coord[0] as! Double)
                        let coordinate = CLLocationCoordinate2DMake(lat, lng)
                        let point = MKMapPointForCoordinate(coordinate)
                        coordinates.append(point)
                        
                        if shouldInitRect {
                            northEastPoint = point
                            southWestPoint = point
                            shouldInitRect = false
                        } else {
                            if point.x > northEastPoint.x {
                                northEastPoint.x = point.x
                            }
                            if point.y > northEastPoint.y {
                                northEastPoint.y = point.y
                            }
                            if point.x < southWestPoint.x {
                                southWestPoint.x = point.x
                            }
                            if point.y < southWestPoint.y {
                                southWestPoint.y = point.y
                            }
                        }
                    }
                }
            }
        }
        
        let mapRect = MKMapRectMake(southWestPoint.x,
                                    southWestPoint.y,
                                    northEastPoint.x - southWestPoint.x,
                                    northEastPoint.y - southWestPoint.y)
        
        return (coordinates, mapRect)
    }
}