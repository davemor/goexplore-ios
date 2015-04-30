//
//  MapViewController.swift
//  Go Explore
//
//  Created by David Morrison on 01/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit
import SQLite
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // model
    // var routes: [Int:Route] = [Int:Route]()
    var polylines: [Int:MKPolyline] = [Int:MKPolyline]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the map delegate
        mapView.delegate = self
        
        // add the routes to the map
        let routes = DataManager.sharedInstance.routes
        for routePair in routes {
            var route = routePair.1
            var points = route.coordinates
            let count = route.coordinates.count
            let polyline = MKPolyline(points: &points, count: count)
            polyline.title = toString(route.id)
            let routeId = route.id
            polylines[routeId] = polyline
            self.mapView.addOverlay(polyline)
        }

        // set the map to be centered on Haddington
        setMapLocation(CLLocationCoordinate2D(latitude: 55.9552045, longitude: -2.7843538), delta: 0.1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setMapLocation(location: CLLocationCoordinate2D, delta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - MKMapView Delegate
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let routes = DataManager.sharedInstance.routes
        let routeId = overlay.title!.toInt()!
        let route = routes[routeId]
        let areaId = route?.primaryAreaId
        let polyline = polylines[routeId]!
        var lineView = MKPolylineRenderer(polyline: polyline)
        
        lineView.strokeColor = Area.color(areaId!)
        lineView.lineWidth = 2
        return lineView
    }
    
    // MARK: Map picking code
    func distanceOfPoint(pt: MKMapPoint, poly: MKPolyline) {
        
        let distance = Float.infinity
        
        for var n = 0; n < poly.pointCount - 1; n++ {
            
        }
        
    }
}





















