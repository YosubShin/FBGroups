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
    var context : NSManagedObjectContext!
    var groupFeed : GroupFeed! {
    didSet {
        NSLog("Set GroupFeed with \(groupFeed)")
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        request.predicate = NSPredicate(format: "group = %@", self.groupFeed)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: "localizedStandardCompare:")]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }

}
