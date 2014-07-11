//
//  GroupFeed+Fetch.swift
//  FBGroups
//
//  Created by Yosub Shin on 7/9/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

extension GroupFeed {
    class func groupFeed(jsonFeed: FBGraphObject!, context: NSManagedObjectContext!) -> GroupFeed! {
        var feed: GroupFeed! = nil
        var request = NSFetchRequest(entityName: "GroupFeed")
        let feedId = jsonFeed["id"] as String
        request.predicate = NSPredicate(format: "id = %@", feedId)
        
        var error: NSError? = nil
        var matches = context.executeFetchRequest(request, error: &error)
        
        if !matches || error || matches.count > 1 {
            //TODO handle error
        } else if matches.count > 0 {
            feed = matches[0] as GroupFeed
        } else {
            feed = NSEntityDescription.insertNewObjectForEntityForName("GroupFeed", inManagedObjectContext: context)
             as GroupFeed
            feed.id = jsonFeed["id"] as String
            feed.name = (jsonFeed["from"] as FBGraphObject)["name"] as String
            if let message = jsonFeed.objectForKey("message") as? String {
                feed.message = message
            }
            feed.updatedTime = jsonFeed["updated_time"] as String
        }
        return feed
    }
    
    class func loadGroupFeeds(data: NSMutableArray, context: NSManagedObjectContext!) {
        for rawFeed : AnyObject in data {
            NSLog("Parsing raw feed \(rawFeed)")
            if rawFeed is FBGraphObject {
                if let jsonFeed = rawFeed as? FBGraphObject {
                    GroupFeed.groupFeed(jsonFeed, context: context)
                }
            }
        }
    }
}
