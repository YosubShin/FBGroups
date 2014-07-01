//
//  ViewController.swift
//  FBGroups
//
//  Created by Yosub Shin on 6/28/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBLoginViewDelegate {
                            
    @IBOutlet var fbLoginView: FBLoginView
    @IBOutlet var loginLabel: UILabel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fbLoginView.readPermissions = ["public_profile", "email", "user_friends", "user_groups"]
        fbLoginView.delegate = self
        loginLabel.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginViewFetchedUserInfo(loginView : FBLoginView, user : FBGraphUser) {
        loginLabel.text = "Hello, \(user.name)"
    }
    
}

