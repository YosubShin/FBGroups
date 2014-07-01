//
//  GropuFeed.swift
//  FBGroups
//
//  Created by Yosub Shin on 6/28/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit

class GroupFeed: NSObject {
    var id : String!
    var name : String!
    var message : String?
    var updatedTime : String!
    
    init(id: String, name: String, message: String, updatedTime: String) {
        self.id = id
        self.name = name
        self.message = message
        self.updatedTime = updatedTime
    }
    
    init(jsonFeed: FBGraphObject) {
        self.id = jsonFeed["id"] as String
        self.name = (jsonFeed["from"] as FBGraphObject)["name"] as String
        if let message = jsonFeed.objectForKey("message") as? String {
            self.message = message
        }
        self.updatedTime = jsonFeed["updated_time"] as String
    }
}
