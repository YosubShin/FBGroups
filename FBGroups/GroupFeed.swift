//
//  GropuFeed.swift
//  FBGroups
//
//  Created by Yosub Shin on 6/28/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

@objc(GroupFeed)
class GroupFeed: NSManagedObject {
    @NSManaged var id : String
    @NSManaged var name : String
    @NSManaged var message : String?
    @NSManaged var updatedTime : String
//    var comments : Array<GroupFeedComment> = []
//    var likes : Int?
 
}
