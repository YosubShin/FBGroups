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
            
            let groupId = (((jsonFeed["to"] as FBGraphObject)["data"] as NSMutableArray)[0] as FBGraphObject)["id"] as String
            let groupName = (((jsonFeed["to"] as FBGraphObject)["data"] as NSMutableArray)[0] as FBGraphObject)["name"] as String
            feed.group = Group.loadGroupWithId(groupId, andName: groupName, inContext: context)
        }
        NSLog("Parsed the GroupFeed object \(feed)")
//        context.save(nil)
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


extension Group {
    class func loadGroupWithId(id: String, andName name: String, inContext context: NSManagedObjectContext) -> Group {
        NSLog("Loading group with id = \(id), and name = \(name)")
        var request = NSFetchRequest(entityName: "Group")
        request.predicate = NSPredicate(format: "id = %@", id)
        var error : NSError? = nil
        var matches = context.executeFetchRequest(request, error: &error)
        
        var group : Group? = nil
        if !matches || error || matches.count > 1 {
            NSLog("Error while fetching Group \(error)")
        } else if matches.count > 0 {
            group = (matches[0] as Group)
        } else {
            group = (NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: context) as Group)
            group!.id = id
            group!.name = name
//            group!.feeds = []
        }
//        context.save(nil)
        return group!
    }
    
    class func loadGroups(data: NSMutableArray, context: NSManagedObjectContext!) {
        for rawGroup : AnyObject in data {
            NSLog("Parsing raw group \(rawGroup)")
            if let jsonGroup = rawGroup as? FBGraphObject {
                Group.loadGroupWithId(jsonGroup["id"] as String, andName: jsonGroup["name"] as String, inContext: context)
            }
        }
    }
}