//
//  NewLogEntryViewController.swift
//  StaticTableTest
//
//  Created by David Morrison on 04/02/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit

class NewLogEntryViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, LocationPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var wildlife: WildlifeEntry?
    
    // wildlife
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wildlifeName: UILabel!
    var imageFileName: String = ""
    
    // location
    @IBOutlet weak var locationLabel: UILabel!
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 55.9552045, longitude: -2.7843538)
    var placemark: CLPlacemark?
    
    // date time
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var editingTime = false
    
    // weather picker
    @IBOutlet weak var weatherPicker: UIPickerView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var editingWeather = false
    
    let weatherList = [
        "Clear Sky",
        "Sunny",
        "Cloudy",
        "Partly Cloudy",
        "Rainy",
        "Snowy",
        "Sleeting",
        "Stormy",
        "Lightning",
        "Thunder",
        "Hailing",
        "Windy",
        "Foggy",
        "Icy"
    ]
    
    // cell heights
    let cellHeights: [[CGFloat]] = [
        [300.0],
        [44.0],
        [44.0, 162.0],
        [44.0, 162.0],
        [64.0]
    ]
    
    // data about sighting
    var dateTime = NSDate()
    var weather = "Sunny"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bind the wildlife
        wildlifeName.text = wildlife!.name.capitalized
        imageView.image = UIImage(named: wildlife!.imageName)
        
        // set up the weather delegate
        weatherPicker.delegate = self
        weatherPicker.dataSource = self
        
        // set the image view to be a circle
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        
        // set the date time picker to now
        setLabelsToDate(dateTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getPhoto(sender: UIButton) {
        
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            var alert = UIAlertController(title: "Unsupported", message: "This device does not have a camera", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated:true, completion:nil)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LocationPickerSegue" {
            var dest = segue.destinationViewController as! LocationPickerViewController
            // if location != nil {
                dest.location = location// ! // if we already have a location set it on the picker
            // }
            dest.delegate = self
        } else if segue.identifier == "LogThisSegue" {
            DataManager.sharedInstance.insertLogEntry(wildlife!.id, location: location, date: datePicker.date, weather: weatherLabel.text!, imageFileName: imageFileName)
        }
    }

    // MARK - TableView delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.section == 2 && indexPath.row == 1) { // this is my picker cell
            if editingTime {
                return 162
            } else {
                return 0
            }
        } else if (indexPath.section == 3 && indexPath.row == 1) {
            if editingWeather {
                return 162
            } else {
                return 0
            }
        } else {
            return cellHeights[indexPath.section][indexPath.row]
        }
    }
    
    @IBAction func weatherCellTapped(sender: UITapGestureRecognizer) {
        editingWeather = !editingWeather
        
        // animate the cell open/close
        UIView.animateWithDuration(0.4, animations: {
            let pathOfPickerCell = NSIndexPath(forRow: 1, inSection: 3)
            self.tableView.reloadRowsAtIndexPaths([pathOfPickerCell], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadData()
            
            let alpha = self.editingWeather ? CGFloat(1.0) : CGFloat(0.0)
            self.weatherPicker.alpha = alpha
            
            let targetColor = self.editingWeather ? UIColor.redColor() : UIColor.blackColor()
            self.weatherLabel.textColor = targetColor
        })
    }

    @IBAction func dataTimeCellTapped(sender: UITapGestureRecognizer) {
        editingTime = !editingTime
        
        // animate the cell open/close
        UIView.animateWithDuration(0.4, animations: {
            let pathOfPickerCell = NSIndexPath(forRow: 1, inSection: 2)
            self.tableView.reloadRowsAtIndexPaths([pathOfPickerCell], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadData()
            
            let alpha = self.editingTime ? CGFloat(1.0) : CGFloat(0.0)
            self.datePicker.alpha = alpha
            
            let targetColor = self.editingTime ? UIColor.redColor() : UIColor.blackColor()
            self.dateLabel.textColor = targetColor
            self.timeLabel.textColor = targetColor
        })
    }
    
    @IBAction func datePickerValueChange(sender: UIDatePicker) {
        setLabelsToDate(sender.date)
        dateTime = sender.date
    }
    
    func setLabelsToDate(date: NSDate) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy!hh:mm a"
        let dateTime = dateFormatter.stringFromDate(date)
        let dateStr = dateTime.componentsSeparatedByString("!")
        
        dateLabel.text = dateStr[0]
        timeLabel.text = dateStr[1]
    }
    
    // MARK - Picker data source and delegate implementation
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let title = weatherList[row]
        weatherLabel.text = title
        weather = title
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let title = weatherList[row]
        return title
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weatherList.count
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK - Location Picker Delegate
    func setALocation(location: CLLocationCoordinate2D) {
        self.location = location
        // locationLabel.text = "\(location.latitude), \(location.longitude)"
    }
    func setAPlacemark(placemark: CLPlacemark) {
        self.placemark = placemark
        locationLabel.text = "\(placemark.locality)"
    }
    
    // MARK - ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // set up the view
        imageView.image = image
        
        // save the image to the image library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        // create a unique file name for the image
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss-SSS" // ms for a unique filename
        let now = NSDate()
        let dateStr = dateFormatter.stringFromDate(now)
        let randomStr = toString(arc4random_uniform(256)) // and a random number
        imageFileName = dateStr + randomStr
        
        // save the image to our local directory so the app can get it back
        let pngData = UIImagePNGRepresentation(image);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsPath = paths[0] as! String
        imageFileName = documentsPath.stringByAppendingPathComponent(imageFileName) + ".png"
        pngData.writeToFile(imageFileName, atomically: true)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
