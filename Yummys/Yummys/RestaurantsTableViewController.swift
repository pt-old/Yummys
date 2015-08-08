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
    var filteredBusinesses : NSArray = NSArray()
    var allBusinesses : NSArray = NSArray()
    
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
    
    var currentLocation : CLLocationCoordinate2D?
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        if (currentLocation == nil ||
            currentLocation!.latitude != locValue.latitude ||
            currentLocation!.longitude != locValue.longitude) {
            currentLocation = locValue
            
                //TEST CODE:
//                self.currentLocation!.latitude = 37.777594
//                self.currentLocation!.longitude = -122.436561
            yelpInterface.queryBusinessInfoForTerm(self.term, location: "\(self.currentLocation!.latitude),\(self.currentLocation!.longitude)") { (allBusinesses, err) -> Void in
                self.allBusinesses = allBusinesses
                self.filteredBusinesses = Filter.sharedInstance.run(self.allBusinesses)
                
                NSLog("locationManager ALL Results=========>")
                self.printBusinesses(self.allBusinesses as! [NSDictionary])
                NSLog("locationManager FILTERED Results=========>")
                self.printBusinesses(self.filteredBusinesses as! [NSDictionary])

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
    
    override func viewWillAppear(animated: Bool) {
        self.filteredBusinesses = Filter.sharedInstance.run(self.allBusinesses)
        NSLog("viewWillAppear FILTERED Results=========>")
        self.printBusinesses(self.filteredBusinesses as! [NSDictionary])
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printBusinesses(businesses:[NSDictionary]) {
        for business:NSDictionary in businesses {
            let name = (business.objectForKey("name") as? String)!
            let cuisinetype:String  = (business.objectForKey("categories") as? NSArray)!.objectAtIndex(0).objectAtIndex(0) as! String
            NSLog("Name = \(name), type = \(cuisinetype)")
        }
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
        return self.filteredBusinesses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CellSubtitle")
            //cell = tableViewCell
        }
        
        let business: NSDictionary = self.filteredBusinesses[indexPath.row] as! NSDictionary
        cell?.textLabel!.text = business.objectForKey("name") as? String
        let cuisinetype:String  = (business.objectForKey("categories") as? NSArray)!.objectAtIndex(0).objectAtIndex(0) as! String
        cell?.detailTextLabel?.text = cuisinetype

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let business: NSDictionary = self.filteredBusinesses[indexPath.row] as! NSDictionary
        let name = business.objectForKey("name") as? String
        let telNum = business.objectForKey("display_phone") as? String
        var alert = UIAlertController(title: "Call \(name!)", message: "\(telNum!)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Call", style: .Default, handler: { action in
            //UIApplication.sharedApplication().openURL(NSURL(string: (telNum!))!)
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(telNum!)")!)
            NSLog("calling restaurantName = \(name!), number = tel:\(telNum)")

        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        

        //UIApplication.sharedApplication().openURL(NSURL(string: (business.objectForKey("display_phone") as? String)!)!)
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
