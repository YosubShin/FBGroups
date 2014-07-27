//
//  GroupFetcher.swift
//  FBGroups
//
//  Created by Yosub Shin on 7/12/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

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
    
    class func fetchGroupsWithCallback(context: NSManagedObjectContext, callback: () -> Void) {
        FBRequestConnection.startWithGraphPath("/me/groups", completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            NSLog("result = \(result)")
            NSLog("error = \(error)")
            
            if !error {
                var jsonGroups = result as FBGraphObject
                Group.loadGroups(jsonGroups["data"] as NSMutableArray, context: context)
                context.save(nil)
                
                callback()
            }
            } as FBRequestHandler)
    }
}