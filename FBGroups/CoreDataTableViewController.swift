//
//  CoreDataTableViewController.swift
//  FBGroups
//
//  Created by Yosub Shin on 7/9/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController : NSFetchedResultsController? {
    didSet {
        if let newfrc = fetchedResultsController {
            NSLog("NSFetchedResultsController is being set in \(object_getClassName(self))")
            newfrc.delegate = self
            self.performFetch()
        } else {
            self.tableView.reloadData()
        }
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performFetch() {
        if let frc = self.fetchedResultsController {
            NSLog("Performing fetch on \(frc)")
            var error : NSError?
            let success = frc.performFetch(&error)
            if !success {
                NSLog("Error fetching")
                if error {
                    NSLog("Error : \(error)")
                }
            }
        }
        self.tableView.reloadData()
    }
    

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        if let frc = self.fetchedResultsController {
            return frc.sections.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        if let frc = self.fetchedResultsController {
            if frc.sections.count > 0 {
                let sectionInfo = frc.sections[section] as NSFetchedResultsSectionInfo
                return sectionInfo.numberOfObjects
            }
        }
        return 0
    }
    
// #pragma mark - NSFetchedResultsControllerDelegate

}
