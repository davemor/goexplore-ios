//
//  WildlifeDetailViewController.swift
//  Go Explore
//
//  Created by David Morrison on 03/01/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit
import SQLite

class WildlifeDetailViewController: UIViewController {

    var wildlifeOpt: WildlifeEntry?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet var collectionOfButtons: Array<UIButton> = []
    @IBOutlet weak var routesHeaderLabel: UILabel!
    
    // constraint for height of description text
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let wl = wildlifeOpt {
            self.navigationItem.title = wl.name.capitalizedString
            self.imageView.image = UIImage(named: wl.imageName)
            self.descriptionTextView.text = wl.description()
            textViewDidChange(descriptionTextView)
            
            // for each route that the wildlife is on - TODO: There is a maximum number of buttons - make this dynamic
            for var idx = 0; idx < wl.routes.count; ++idx {
                routesHeaderLabel.hidden = false
                if idx < collectionOfButtons.count {
                    // bind button number idx
                    var button = collectionOfButtons[idx]
                    let route = DataManager.sharedInstance.routes[wl.routes[idx]]!
                    button.setTitle("\(route.routeNumber)", forState: UIControlState.Normal)
                    let areaId = route.primaryAreaId
                    let area = DataManager.sharedInstance.areasTable[areaId]
                    button.backgroundColor = area?.color()
                    button.layer.cornerRadius = 20
                    button.hidden = false
                    button.tag = route.id
                }
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        
        // let descriptionSize = descriptionTextView.contentSize;
        let width = descriptionTextView.frame.size.width
        let size = descriptionTextView.sizeThatFits(CGSizeMake(width, CGFloat.max))
        
        textViewHeightConstraint.constant = size.height * 0.8 // HACK - sizeThatFits is consistantly to big so I'm just going to scale it
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.transitionCoordinator()?.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            
            // set the colour of the header
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#29A005")
            self.navigationController?.navigationBar.translucent = false
            
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRouteButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("RouteDetailsSegue", sender: sender.tag)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "RouteDetailsSegue" {
        
            let routeId = sender as! Int
            var routeDetailVC = segue.destinationViewController as! RouteDetailsViewController
            
            routeDetailVC.route = DataManager.sharedInstance.routes[routeId]
            let areaId = DataManager.sharedInstance.routes[routeId]?.primaryAreaId
            if areaId > 0 {
                routeDetailVC.area = DataManager.sharedInstance.areasTable[areaId!]
            } else {
                routeDetailVC.area = DataManager.sharedInstance.areas[0]
            }
        } else if segue.identifier == "LogSightingSegue" {
            var dest = segue.destinationViewController as! NewLogEntryViewController
            dest.wildlife = wildlifeOpt
        }
    }
}
