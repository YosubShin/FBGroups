//
//  CommentFetcher.swift
//  FBGroups
//
//  Created by Yosub Shin on 7/12/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

extension Comment {
    class func comment(groupFeed: GroupFeed, jsonComment: FBGraphObject!, context: NSManagedObjectContext!) -> Comment! {
        var comment: Comment! = nil
        var request = NSFetchRequest(entityName: "Comment")
        let commentId = jsonComment["id"] as String
        request.predicate = NSPredicate(format: "id = %@", commentId)
        
        var error: NSError? = nil
        var matches = context.executeFetchRequest(request, error: &error)
        
        if !matches || error || matches.count > 1 {
            //TODO handle error
        } else if matches.count > 0 {
            comment = matches[0] as Comment
        } else {
            comment = NSEntityDescription.insertNewObjectForEntityForName("Comment", inManagedObjectContext: context) as Comment
            comment.id = jsonComment["id"] as String
            comment.name = (jsonComment["from"] as FBGraphObject)["name"] as String
            if let message = jsonComment.objectForKey("message") as? String {
                comment.message = message
            }
            comment.createdTime = jsonComment["created_time"] as String
            comment.groupFeed = groupFeed
//            if let likeCount = jsonComment["like_count"] as? Int {
//                comment.likeCount = likeCount
//            }
        }
        NSLog("Parsed the Comment object \(comment)")
        return comment
    }
    
    class func loadComments(groupFeed: GroupFeed, data: NSMutableArray, context: NSManagedObjectContext!) -> Array<Comment> {
        var result : Array<Comment> = []
        for rawComment : AnyObject in data {
            NSLog("Parsing raw comment \(rawComment)")
            if rawComment is FBGraphObject {
                if let jsonComment = rawComment as? FBGraphObject {
                    result.append(Comment.comment(groupFeed, jsonComment: jsonComment, context: context))
                }
            }
        }
        return result
    }
}
