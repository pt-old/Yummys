//
//  SettingsTableViewController.swift
//  Yummys
//
//  Created by Piyush Tank on 7/21/15.
//  Copyright (c) 2015 Piyush Tank. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var saveBarButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.separatorEffect = UIVibrancyEffect()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveSettings" )
        //self.tableView.allowsSelection = false
        //self.tableView.separatorColor = UIColor.blueColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveSettings () {
        Settings.sharedInstance.save()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.sharedInstance.cuisines.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SETTINGS_CELL", forIndexPath: indexPath) as! SettingsTableViewCell
        var  keys:[String] = Settings.sharedInstance.cuisines.allKeys as! [String]
        let sortedCuisines =  Array(keys).sorted(<)
        
        cell.titleLable!.text = sortedCuisines[indexPath.row]
        cell.theSwitch.on = Settings.sharedInstance.cuisines[sortedCuisines[indexPath.row]] as! Bool
        cell.cuisineKey = sortedCuisines[indexPath.row]
        if (cell.theSwitch.on) {
            //cell.titleLable!.textColor = UIColor.whiteColor()
            //cell.backgroundColor = UIColor.purpleColor()
        } else {
            //cell.titleLable.textColor = UIColor.grayColor()
        }
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SettingsTableViewCell
        cell.didSelect()
        cell.setHighlighted(false, animated: false)

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
