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
        fetchGroups()
        addRefreshControl()
    }
    
    func fetchGroups() {
        Group.fetchGroupsWithCallback(context, callback: {() -> Void in self.tableView.reloadData()})
        NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("stopRefresh"), userInfo: nil, repeats: false)
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

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject?) {
        if segue.destinationViewController is GroupFeedTableViewController {
            var destViewController = segue.destinationViewController as GroupTableViewController
            if let frc = self.fetchedResultsController {
                let group = frc.objectAtIndexPath(self.tableView.indexPathForSelectedRow()) as Group
                destViewController.group = group
            }
        } else {
            NSLog("Settings modal")
        }
    }
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue!) {
        NSLog("Unwind from settings view")
    }
    
    // #pragma mark - FetchedResultsController
    func setupFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Group")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedStandardCompare:")]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // #pragma mark - Refresh Control
    
    func addRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "fetchGroups", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
    }
    
    func stopRefresh() {
        self.refreshControl.endRefreshing()
    }

}
