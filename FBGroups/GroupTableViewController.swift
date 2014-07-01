//
//  GroupTableViewController.swift
//  FBGroups
//
//  Created by Yosub Shin on 6/28/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    var groupName : String!
    var groupId : String!
    var feeds: Array<GroupFeed> = []
    
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

        fetchFacebookGroup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = groupName
        
        
    }
    
    func fetchFacebookGroup() {
        FBRequestConnection.startWithGraphPath("\(groupId)/?fields=feed.limit=(1)", completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if result? {
                NSLog("error = \(error)")
            
                var jsonFeeds = result as FBGraphObject
                self.feeds = self.buildFeeds((jsonFeeds["feed"] as FBGraphObject)["data"] as NSMutableArray)
                self.tableView.reloadData()
            }
            } as FBRequestHandler)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildFeeds(data: NSMutableArray) -> Array<GroupFeed> {
        var result : Array<GroupFeed> = []
        for rawFeed : AnyObject in data {
            if rawFeed is FBGraphObject {
                if let jsonFeed = rawFeed as? FBGraphObject {
                    var feed = GroupFeed(jsonFeed: jsonFeed)
                    result += feed
                }
            }
        }
        return result
    }

    // #pragma mark - Table view data source

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return feeds.count
    }


    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell = tableView!.dequeueReusableCellWithIdentifier("GroupPostCell") as UITableViewCell
        
        let feed = self.feeds[indexPath!.row]
        
        cell.textLabel!.text = feed.name
        if let message = feed.message {
            cell.detailTextLabel.text = message
        }

        // Configure the cell...

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

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
