//
//  GroupFeedTableViewController.swift
//  FBGroups
//
//  Created by Yosub Shin on 7/12/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

class GroupFeedTableViewController: CoreDataTableViewController {
    let kCellIdentifier = "CommentCell"
    
    var groupFeed : GroupFeed! {
    didSet {
        NSLog("Set group feed with \(groupFeed)")
        self.setupFetchedResultsController()
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
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = groupFeed.name
        
        tableView.allowsSelection = false

        // Self-sizing table view cells in iOS 8 require that the rowHeight property of the table view be set to the constant UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        tableView.estimatedRowHeight = 44.0 // set this to whatever your "average" cell height is; it doesn't need to be very accurate
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // #pragma mark - Table view data source
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell = tableView!.dequeueReusableCellWithIdentifier(kCellIdentifier) as CommentCell
        
        if let frc = self.fetchedResultsController {
            let comment = frc.objectAtIndexPath(indexPath) as Comment
            cell.titleLabel.text = comment.name
            cell.bodyLabel.text = comment.message
            
            // Make sure the constraints have been added to this cell, since it may have just been created from scratch
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
        }
        return cell
    }
    
    func setupFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Comment")
        request.predicate = NSPredicate(format: "groupFeed = %@", self.groupFeed)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: "localizedStandardCompare:")]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.groupFeed.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }

}
