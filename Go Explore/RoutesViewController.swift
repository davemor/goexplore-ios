//
//  RoutesViewController.swift
//  Go Explore
//
//  Created by David Morrison on 04/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit
import MapKit
import SQLite

class RoutesViewController: UITabBarController, MKMapViewDelegate {

    var routesDict = [Int: Route]()
    var areas = [Area]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // query the database for the routes table, then draw all the routes on the map
        if var path = NSBundle.mainBundle().pathForResource("walks", ofType: "db") {
            let db = Database(path)
            
            // load the routes dictionary
            let routeTable = db["route"]
            for routeRow in routeTable {
                let route = Route.fromRow(routeRow)
                routesDict[route.id] = route
            }
            
            // load mappings of routes to tables
            let routeInAreaTable = db["route_in_area"]
            let routeIdCol = Expression<Int>("route_id")
            let areaIdCol = Expression<Int>("area_id")
            var areaToRoutes = [(Int, Int)]()
            for row in routeInAreaTable {
                let areaId = row[areaIdCol]
                let routeId = row[routeIdCol]
                areaToRoutes.append((areaId, routeId))
            }
            let routesForAreas = areaToRoutes.groupBy({$0.0}).map(
                { (key, values) -> (Int, [Int]) in
                    return (key, values.map({$0.1}))
            })
            
            // load the areas list with routes in area
            let areaTable = db["area"]
            for areaRow in areaTable {
                var area = Area.fromRow(areaRow)
                if var routesList = routesForAreas[area.id] {
                    area.routeIds = routesList
                }
                areas.append(area)
            }
   
        } else {
            println("Unable to find database file walks")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}








