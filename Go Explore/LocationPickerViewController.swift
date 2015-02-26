//
//  LocationPickerViewController.swift
//  Go Explore
//
//  Created by David Morrison on 04/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit
import MapKit

class LocationPickerViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var gestureRecognizer: UILongPressGestureRecognizer!
    
    var delegate: LocationPickerDelegate?
    var location = CLLocationCoordinate2D(latitude: 55.9552045, longitude: -2.7843538)
    var placemark: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // zoom into to the default position
        setMapLocation(location, delta: 0.1)
        getPlacemarkFromLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        addAnnotation(location)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func longPressOnMap(sender: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            location = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            mapView.removeAnnotations(mapView.annotations)
            addAnnotation(location)
        }
    }

    @IBAction func useLocationButtonPressed(sender: UIButton) {
        delegate?.setLocation(location)
        if placemark != nil {
            delegate?.setPlacemark(placemark!)
        }
        self.navigationController?.popViewControllerAnimated(true)
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

    func addAnnotation(location: CLLocationCoordinate2D) {
        var annot = MKPointAnnotation()
        annot.coordinate = location
        mapView.addAnnotation(annot)
    }
    
    func getPlacemarkFromLocation(location: CLLocation){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    //println("reverse geodcode fail: \(error.localizedDescription)")
                }
                let pm = placemarks as [CLPlacemark]
                if pm.count > 0 {
                    // println(pm[0])
                    self.placemark = pm[0]
                }
        })
    }
}

protocol LocationPickerDelegate {
    func setLocation(location: CLLocationCoordinate2D)
    func setPlacemark(placemark: CLPlacemark)
}






