//
//  DataManager.swift
//  Go Explore
//
//  Created by David Morrison on 03/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import Foundation
import SQLite
import MapKit

// This class is a little strange.
// I was experiencing problems with the performance of the SQLite.swift queries.
// So this class does them all at load time (for the static data) and caches the results.
// Slightly longer load time in exchange for much better in app performance.
// Sort of like an in memory db with lots of indices
class DataManager {
    
    // model
    var routes: [Int:Route] = [Int:Route]()
    var areas: [Area] = [Area]()
    var areasTable: [Int:Area] = [Int:Area]()
    var wildlifeList = [WildlifeEntry]()
    var wildlifeTable = [Int:WildlifeEntry]()
    var logEntriesTable = [Int:[LogEntry]]()

    // shared singleton instance
    class var sharedInstance: DataManager {
        struct Static {
            static var instance: DataManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DataManager()
        }
        
        return Static.instance!
    }
    
    init() {
        // TODO - This could do with being refactored into smaller function with their own scope.
        
        // set up the database if we need to
        createEditableCopyOfDatabaseIfNeeded()
        
        // query the database for the routes table, then draw all the routes on the map
        let path = writableDatabasePath()
        let db = Database(path)
        
        // load the routes dictionary
        let routeTable = db["route"]
        for routeRow in routeTable {
            let route = Route.fromRow(routeRow)
            routes[route.id] = route
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
        let routesForAreas = areaToRoutes.groupBy(groupingFunction: {$0.0}).map(
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
            areasTable[area.id] = area
        }
        
        // load up the wildlife
        let wildlife = db["wildlife"]
        let id = Expression<Int>("_id")
        let name = Expression<String>("name")
        let imageName = Expression<String>("image_name")
        let desc = Expression<String>("description")
        
        // iterate over the wildlife and use them to populate the grid
        for wildlifeKind in wildlife {
            // println("name: \(wildlifeKind[name]), image_name: \(wildlifeKind[imageName])")
            let newWildlife = WildlifeEntry(id: wildlifeKind[id],
                                            name: wildlifeKind[name],
                                            imageName: wildlifeKind[imageName],
                                            desc: wildlifeKind[desc] )
            wildlifeList.append(newWildlife)
            wildlifeTable[newWildlife.id] = newWildlife
        }
        
        // load in the wildlife that is on routes
        let wildlifeOnRouteTable = db["wildlife_on_route"]
        let wildlifeIdExp = Expression<Int>("wildlife_id")
        let routeIdExp = Expression<Int>("route_id")
        for wildlifeOnRouteRow in wildlifeOnRouteTable {
            let wildlifeId = wildlifeOnRouteRow[wildlifeIdExp]
            let routeId = wildlifeOnRouteRow[routeIdExp]
            routes[routeId]?.wildlife.append(wildlifeId)
            wildlifeTable[wildlifeId]?.routes.append(routeId)
        }
        
        logEntriesTable = getLogEntriesTable()
    }
    
    func writableDatabasePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as! String
        let writableDBPath = documentsDirectory.stringByAppendingPathComponent("walks.db")
        return writableDBPath
    }
    
    func createEditableCopyOfDatabaseIfNeeded() {
        let writableDBPath = writableDatabasePath()
        let fileManager = NSFileManager.defaultManager()
        let found = fileManager.fileExistsAtPath(writableDBPath)
        if !found {
            // var error:NSError?
            if let defaultDBPath = NSBundle.mainBundle().pathForResource("walks", ofType: "db") {
                var error:NSError?
                let success = fileManager.copyItemAtPath(defaultDBPath, toPath: writableDBPath, error: &error)
                if !success {
                   // println("Failed to copy database file walks.db")
                }
            } else {
                // println("Cannot find database file walks.db")
            }
        } else {
            // println("No need to copy the database.")
        }
    }
    
    func insertLogEntry(wildlifeId: Int, location: CLLocationCoordinate2D, date: NSDate, weather: String, imageFileName: String) {
        
        let path = writableDatabasePath()
        let db = Database(path)
        let logTable = db["log_entry"]
    
        // declare sqlite.swift Expressions for each column
        let wildlifeIdExp = Expression<Int>("wildlife_id")
        let latExp = Expression<String>("lat")
        let lngExp = Expression<String>("lng")
        let dateTimeExp = Expression<String>("datetime")
        let weatherExp = Expression<String>("weather")
        let imageExp = Expression<String>("image")
        
        // transform some values
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.stringFromDate(date)
        
        // insert the values into the the database
        if let insertID = logTable.insert(
            wildlifeIdExp <- wildlifeId,
            latExp <- toString(location.latitude),
            lngExp <- toString(location.longitude),
            dateTimeExp <- dateStr,
            weatherExp <- weather,
            imageExp <- imageFileName
        ) {
            // println("inserted id: \(insertID)")
            
            // insert into the logEntriesTable, so the model and the database are in-sync
            let entry = LogEntry(id: Int(insertID), wildlifeId: wildlifeId, location: location, date: date, weather: weather, image: loadImage(imageFileName))
            
            // let entry = LogEntry(id: Int, wildlifeId: Int, location: CLLocationCoordinate2D, date: NSDate, weather: String, image: UIImage)
            
            
            if var entryList = logEntriesTable[entry.wildlifeId] {
                entryList.append(entry)
            } else {
                logEntriesTable[entry.wildlifeId] = [entry]
            }
        }
    }
    
    func getLogEntriesTable() -> [Int:[LogEntry]] {
        // get all the log entries and group them by their wildlife ids
        let path = writableDatabasePath()
        let db = Database(path)
        
        let idExp = Expression<Int>("_id")
        let wildlifeIdExp = Expression<Int>("wildlife_id")
        let latExp = Expression<String>("lat")
        let lngExp = Expression<String>("lng")
        let dateTimeExp = Expression<String>("datetime")
        let weatherExp = Expression<String>("weather")
        let imageExp = Expression<String>("image")
        
        // helpers
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var entries = [LogEntry]()
        for row in db["log_entry"] {
            
            let id = row[idExp]
            let wildlifeId = row[wildlifeIdExp]
            let location = CLLocationCoordinate2D(latitude:  row[latExp].toDouble()!,
                                                  longitude: row[lngExp].toDouble()!)
            let date = dateFormatter.dateFromString(row[dateTimeExp])
            let weather = row[weatherExp]
            let image = loadImage(row[imageExp])
            
            let logEntry = LogEntry(id: id, wildlifeId: wildlifeId, location: location, date: date!, weather: weather, image: image)
            entries.append(logEntry)
        }
        
        return entries.groupBy(groupingFunction: { $0.wildlifeId })
    }
    
    func loadImage(filePath:String) -> UIImage {
        if let image = UIImage(contentsOfFile: filePath) {
            return image
        } else {
            return UIImage() // TODO: could use a default image?
        }
    }
    
    func deleteLogEntry(logEntry:LogEntry) {
        
        // remove it from the database
        let path = writableDatabasePath()
        let db = Database(path)
        
        let idExp = Expression<Int>("_id")
        var table = db["log_entry"]
        
        let entry = table.filter(idExp == logEntry.id)
        if entry.delete() > 0 {
           // println("deleted entry \(logEntry.id)")
        }
        
        // reload the log entries
        logEntriesTable = getLogEntriesTable()
    }
}

























