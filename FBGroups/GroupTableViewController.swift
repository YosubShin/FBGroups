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
    
    var context : NSManagedObjectContext!
    var group : Group! {
    didSet {
        NSLog("Set group with \(group)")
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

        tableView.allowsSelection = false
        
        tableView.registerClass(GroupFeedTableViewCell.self, forCellReuseIdentifier: kCellIdentifier) // uncomment this line to load table view cells programmatically
        
        // Self-sizing table view cells in iOS 8 require that the rowHeight property of the table view be set to the constant UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        tableView.estimatedRowHeight = 44.0 // set this to whatever your "average" cell height is; it doesn't need to be very accurate
        
        fetchFacebookGroup()
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
    
    func fetchFacebookGroup() {
        FBRequestConnection.startWithGraphPath("\(group.id)/?fields=feed", completionHandler: {(connection: FBRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
            if error? {
                NSLog("Error \(error)")
            }
            if let result : AnyObject = result {
                var rawFeeds = result as FBGraphObject
                
                if let jsonFeeds = rawFeeds.objectForKey("feed") as? FBGraphObject {
                    GroupFeed.loadGroupFeeds(jsonFeeds["data"] as NSMutableArray, context: self.context)
                    self.context.save(nil)
                    self.tableView.reloadData()
                }
            }
            } as FBRequestHandler)
        NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("stopRefresh"), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell = tableView!.dequeueReusableCellWithIdentifier(kCellIdentifier) as GroupFeedTableViewCell
        cell.updateFonts()
        
        if let frc = self.fetchedResultsController {
            let feed = frc.objectAtIndexPath(indexPath) as GroupFeed
            cell.titleLabel.text = feed.name
            if let message = feed.message {
                cell.bodyLabel.text = message
            }
            
            // Make sure the constraints have been added to this cell, since it may have just been created from scratch
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
        }
        return cell
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupFetchedResultsController() {
        let request = NSFetchRequest(entityName: "GroupFeed")
        request.predicate = NSPredicate(format: "group = %@", self.group)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: "localizedStandardCompare:")]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // #pragma mark - Refresh Control
    
    func addRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "fetchFacebookGroup", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
    }
    
    func stopRefresh() {
        self.refreshControl.endRefreshing()
    }

}
