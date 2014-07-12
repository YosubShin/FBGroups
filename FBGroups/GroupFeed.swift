//
//  GropuFeed.swift
//  FBGroups
//
//  Created by Yosub Shin on 6/28/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

//@objc(GroupFeed) // instead of doing this, change class name in .xcdatamodeld file to MyProjectName.MyClassName
class GroupFeed: NSManagedObject {
    @NSManaged var id : String
    @NSManaged var name : String
    @NSManaged var message : String?
    @NSManaged var updatedTime : String
//    @NSManaged var group : Group
//    var comments : Array<GroupFeedComment> = []
//    var likes : Int?
}
