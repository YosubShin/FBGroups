//
//  GroupTableViewController.swift
//  FBGroups
//
//  Created by Yosub Shin on 6/28/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

class GroupTableViewController: CoreDataTableViewController {
    let kCellIdentifier = "GroupFeedCell"
    
    var group : Group! {
    didSet {
        self.setupFetchedResultsController()
    }
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        
        self.title = group.name
        
        // Check out http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights for more explanation
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        fetchGroupFeeds()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    // This function will be called when the Dynamic Type user setting changes (from the system Settings app)
    func contentSizeCategoryChanged(notification: NSNotification)
    {
        tableView.reloadData()
    }
    
    func fetchGroupFeeds() {
        GroupFeed.fetchGroupFeedsWithCallback(self.group,
            context: self.group.managedObjectContext,
            callback: {() -> Void in self.tableView.reloadData()})
        NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("stopRefresh"), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell = tableView!.dequeueReusableCellWithIdentifier(kCellIdentifier) as GroupFeedCell
        
        if let frc = self.fetchedResultsController {
            let feed = frc.objectAtIndexPath(indexPath) as GroupFeed
            cell.titleLabel.text = feed.name
            if let message = feed.message {
                cell.bodyLabel.text = message
            }
        }
        return cell
    }

    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        var cell = tableView!.dequeueReusableCellWithIdentifier(kCellIdentifier) as GroupFeedCell
        
        // Configure the cell
        if let frc = self.fetchedResultsController {
            let feed = frc.objectAtIndexPath(indexPath) as GroupFeed
            cell.titleLabel.text = feed.name
            if let message = feed.message {
                cell.bodyLabel.text = message
            }
        }
        
        // Get the height
        var height : CGFloat = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        return height
    }
    
    func setupFetchedResultsController() {
        let request = NSFetchRequest(entityName: "GroupFeed")
        request.predicate = NSPredicate(format: "group = %@", self.group)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: "localizedStandardCompare:")]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.group.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // #pragma mark - Refresh Control
    
    func addRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "fetchGroupFeeds", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
    }
    
    func stopRefresh() {
        self.refreshControl.endRefreshing()
    }
    
    // #pragma mark - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject?) {
        var newVC = segue.destinationViewController as GroupFeedTableViewController
        if let frc = self.fetchedResultsController {
            let feed = frc.objectAtIndexPath(self.tableView.indexPathForSelectedRow()) as GroupFeed
            newVC.groupFeed = feed
            newVC.title = feed.name
        }
    }

    

}
