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
            
            if let rawComments = jsonFeed["comments"] as? FBGraphObject {
                Comment.loadComments(feed, data: rawComments["data"] as NSMutableArray, context: context)
//                for comment in Comment.loadComments(rawComments["data"] as NSMutableArray, context: context) {
//                    feed.comments.append(comment)
//                }
            }
        }
        NSLog("Parsed the GroupFeed object \(feed)")
        return feed
    }
    
    class func loadGroupFeeds(data: NSMutableArray?, context: NSManagedObjectContext!) {
        if let data = data {
            for rawFeed : AnyObject in data {
                if rawFeed is FBGraphObject {
                    if let jsonFeed = rawFeed as? FBGraphObject {
                        GroupFeed.groupFeed(jsonFeed, context: context)
                    }
                }
            }
        }
    }
    
    class func fetchGroupFeedsWithCallback(group: Group, context: NSManagedObjectContext, callback: () -> Void) {
        FBRequestConnection.startWithGraphPath("\(group.id)/?fields=feed", completionHandler: {(connection: FBRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
            if error? {
                NSLog("Error \(error)")
            }
            if let result : AnyObject = result {
                var rawFeeds = result as FBGraphObject
                
                if let jsonFeeds = rawFeeds.objectForKey("feed") as? FBGraphObject {
                    GroupFeed.loadGroupFeeds(jsonFeeds["data"] as? NSMutableArray, context: context)
                    context.save(nil)
                    callback()
                }
            }
            } as FBRequestHandler)
    }
}

