//
//  RouteDetailsViewController.swift
//  Go Explore
//
//  Created by David Morrison on 01/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit
import MapKit
import SQLite

class RouteDetailsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var routeNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var surfaceLabel: UILabel!
    @IBOutlet weak var whatYouMightSeeLabel: UILabel!

    @IBOutlet var wildlifeButtons: [UIButton]!
    
    
    var route:Route?
    var area:Area?
    
    var polyline: MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // bind the view to the route and area
        routeNumberLabel.text = toString(route!.routeNumber)
        descriptionLabel.text = route?.description
        areaLabel.text = area?.name
        lengthLabel.text = toString(route!.length)
        headerBackgroundView.backgroundColor = area?.color()
        
        // draw the route on the map view
        var points = route!.coordinates
        let count = route!.coordinates.count
        polyline = MKPolyline(points: &points, count: count)
        polyline?.title = toString(route!.id)
        self.mapView.addOverlay(polyline)
        
        // move the camera to look at the map
        let rect = route?.mapBounds
        let region = MKCoordinateRegionForMapRect(rect!)
        mapView.setRegion(region, animated: true)
        
        // bind the footer information
        surfaceLabel.text = route?.surface
        
        // bind the wildlife buttons
        let wildlifeList = DataManager.sharedInstance.routes[route!.id]?.wildlife
        var buttonIdx = 0
        for wildlifeId in wildlifeList! {
            if buttonIdx < wildlifeButtons.count {
                whatYouMightSeeLabel.hidden = false
                let wildlife = DataManager.sharedInstance.wildlifeTable[wildlifeId]
                var button = wildlifeButtons[buttonIdx]
                let image = UIImage(named: wildlife!.imageName)
                button.setBackgroundImage(image, forState: UIControlState.Normal)
                button.tag = wildlifeId
                button.layer.cornerRadius = 32
                button.layer.masksToBounds = true
                button.hidden = false
            }
            ++buttonIdx
        }
    }
    
    @IBAction func wildlifeButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("WildlifeDetailSegue", sender: sender.tag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WildlifeDetailSegue" {
            let wildlifeId = sender as Int
            let destination = segue.destinationViewController as WildlifeDetailViewController
            destination.wildlifeOpt = DataManager.sharedInstance.wildlifeTable[wildlifeId]
        }
    }
        
    override func viewWillAppear(animated: Bool) {
        let areaConst = area!
        self.transitionCoordinator()?.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            
            // set the colour of the header
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.barTintColor = areaConst.color()
            self.navigationController?.navigationBar.translucent = false
            
        }, completion: nil)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        var lineView = MKPolylineRenderer(polyline: polyline!)
        lineView.strokeColor = area!.color()
        lineView.lineWidth = 2
        return lineView
    }
    
}









