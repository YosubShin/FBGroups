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
    var context : NSManagedObjectContext {
    get {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.managedObjectContext
    }
    }
    
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
    }
    
    func fetchFacebookGroups() {
        FBRequestConnection.startWithGraphPath("/me/groups", completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            NSLog("result = \(result)")
            NSLog("error = \(error)")

            var jsonGroups = result as FBGraphObject
            Group.loadGroups(jsonGroups["data"] as NSMutableArray, context: self.context)
            self.context.save(nil)
            
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

    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject?) {
        var destViewController = segue.destinationViewController as GroupTableViewController
        if let frc = self.fetchedResultsController {
            let group = frc.objectAtIndexPath(self.tableView.indexPathForSelectedRow()) as Group
            destViewController.context = self.context
            destViewController.group = group
        }
    }
    
    // #pragma mark - FetchedResultsController
    func setupFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Group")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedStandardCompare:")]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }

}
