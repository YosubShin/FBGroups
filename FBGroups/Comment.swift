//
//  Comment.swift
//  FBGroups
//
//  Created by Yosub Shin on 7/12/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

class Comment: NSManagedObject {
    @NSManaged var id : String
    @NSManaged var name : String
    @NSManaged var message : String
    @NSManaged var createdTime : String
    @NSManaged var likeCount : Int
    @NSManaged var groupFeed : GroupFeed
}
