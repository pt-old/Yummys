//
//  RestaurantsTableViewController.swift
//  Yummys
//
//  Created by Piyush Tank on 7/21/15.
//  Copyright (c) 2015 Piyush Tank. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let yelpInterface = YelpInterface()
    let term = "dinner"
    ///let location = "Sunnyvale, CA"
    
    let locationManager:CLLocationManager! = CLLocationManager()
    var myLocations: [CLLocation] = []
    var businesses : NSArray = NSArray()
    
    
    var settingsViewController : UINavigationController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = mainStoryboard.instantiateViewControllerWithIdentifier("SettingsNavigationController") as! UINavigationController
        return settingsVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: "loadSettings")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!)
    {
        print("hi")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var locValue:CLLocationCoordinate2D = locationManager.location.coordinate
        if (currentLocation != nil) {
            //println("locations = \(locValue.latitude),\(locValue.longitude)")
            
            yelpInterface.queryBusinessInfoForTerm(self.term, location: "\(self.currentLocation!.latitude),\(self.currentLocation!.longitude)") { (businesses, err) -> Void in
                for business:NSDictionary in businesses as! [NSDictionary] {
                    NSLog((business.objectForKey("name") as? String)!)
                }
                self.businesses = Filter.sharedInstance.run(businesses)
                dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
            }
        }
    }
    


    var currentLocation : CLLocationCoordinate2D?
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        if (currentLocation == nil ||
            currentLocation!.latitude != locValue.latitude ||
            currentLocation!.longitude != locValue.longitude) {
            currentLocation = locValue
            //println("locations = \(locValue.latitude),\(locValue.longitude)")
            
            yelpInterface.queryBusinessInfoForTerm(self.term, location: "\(self.currentLocation!.latitude),\(self.currentLocation!.longitude)") { (businesses, err) -> Void in
                for business:NSDictionary in businesses as! [NSDictionary] {
                    NSLog((business.objectForKey("name") as? String)!)
                }
                self.businesses = Filter.sharedInstance.run(businesses)
                dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
            }
        }
    }


    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let firstLaunch = defaults.stringForKey("FirstTimeLaunch")
        if (firstLaunch == nil) {
            loadSettings()
        }
        defaults.setValue("NO", forKey: "FirstTimeLaunch")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSettings() {
        presentViewController(settingsViewController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return businesses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RESTAURANTS_CELL", forIndexPath: indexPath) as! UITableViewCell
        
        let business: NSDictionary = businesses[indexPath.row] as! NSDictionary
        cell.textLabel!.text = business.objectForKey("name") as? String

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
