//
//  Group.swift
//  FBGroups
//
//  Created by Yosub Shin on 7/11/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit
import CoreData

//@objc(Group)
class Group: NSManagedObject {
    @NSManaged var id : String
    @NSManaged var name : String
    @NSManaged var feeds : Array<GroupFeed>
}
