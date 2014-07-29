//
//  ViewController.swift
//  FBGroups
//
//  Created by Yosub Shin on 6/28/14.
//  Copyright (c) 2014 yosubshin. All rights reserved.
//

import UIKit

let FACEBOOK_PERMISSIONS = ["public_profile", "email", "user_friends", "user_groups"]

class LoginViewController: UIViewController, FBLoginViewDelegate {
    @IBOutlet var fbLoginView: FBLoginView!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fbLoginView.readPermissions = FACEBOOK_PERMISSIONS
        fbLoginView.delegate = self
        loginLabel.text = ""
        
        if FBSession.activeSession().state != .CreatedTokenLoaded {
            self.getStartedButton.hidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginViewFetchedUserInfo(loginView : FBLoginView, user : FBGraphUser) {
        loginLabel.text = "Hello, \(user.name)"
        
        self.getStartedButton.hidden = false
    }
    
}

