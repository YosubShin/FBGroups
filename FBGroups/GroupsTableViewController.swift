//
//  GroupsTableViewController.swift
//  FBGroups
//
//  Created by Yosub Shin on 6/28/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

class GroupsTableViewController: CoreDataTableViewController {
//    var groups : NSMutableArray!

    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        
        fetchFacebookGroups()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchFacebookGroups() {
        FBRequestConnection.startWithGraphPath("/me/groups", completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            NSLog("result = \(result)")
            NSLog("error = \(error)")

            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context = appDelegate.managedObjectContext
            var jsonGroups = result as FBGraphObject
            Group.loadGroups(jsonGroups["data"] as NSMutableArray, context: context)
            appDelegate.saveContext()
            
//            self.groups = jsonGroups["data"] as NSMutableArray
            self.tableView.reloadData()
            
            } as FBRequestHandler)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell = tableView!.dequeueReusableCellWithIdentifier("GroupNameCell") as UITableViewCell
        
        if let frc = self.fetchedResultsController {
            let group = frc.objectAtIndexPath(indexPath) as Group
            cell.textLabel.text = group.name
        }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
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
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject?) {
        var destViewController = segue.destinationViewController as GroupTableViewController
        if let frc = self.fetchedResultsController {
            let group = frc.objectAtIndexPath(self.tableView.indexPathForSelectedRow()) as Group
            destViewController.groupId = group.id
            destViewController.groupName = group.name
        }
    }
    
    // #pragma mark - FetchedResultsController
    func setupFetchedResultsController() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Group")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedStandardCompare:")]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }

}
