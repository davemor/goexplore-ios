//
//  RouteSegmentViewController.swift
//  Go Explore
//
//  Created by David Morrison on 01/02/2015.
//  Copyright (c) 2015 East Lothian Coucil. All rights reserved.
//

import UIKit

class RouteSegmentViewController: UIViewController {
    
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    @IBOutlet var contentView: UIView!
    
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vc = self.viewControllerForSegmentIndex(self.typeSegmentedControl.selectedSegmentIndex)!
        self.addChildViewController(vc)
        vc.view.frame = self.contentView.bounds
        self.contentView.addSubview(vc.view)
        self.currentViewController = vc
        
        self.title = "Core Paths"
    }
    
    override func viewWillAppear(animated: Bool) {
        self.transitionCoordinator()?.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            
            // set the colour of the header
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#29A005")
            self.navigationController?.navigationBar.translucent = false
            
            }, completion: nil)
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        let vc = viewControllerForSegmentIndex(sender.selectedSegmentIndex)!
        addChildViewController(vc)
        transitionFromViewController(
            self.currentViewController!,
            toViewController: vc,
            duration: 0.25,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { () -> Void in
                self.currentViewController?.view.removeFromSuperview()
                vc.view.frame = self.contentView.bounds
                self.contentView.addSubview(vc.view)
            },
            completion: { (finished:Bool) -> Void in
                vc.didMoveToParentViewController(self)
                self.currentViewController?.removeFromParentViewController()
                self.currentViewController = vc
        })
    }

    func viewControllerForSegmentIndex(index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch (index) {
        case 0:
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("RouteListViewController") as? UIViewController
        case 1:
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as? UIViewController
        default:
            println()//"Failed to find view controller for segment")
        }
        return vc
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
