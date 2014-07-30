//
//  AppDelegate.swift
//  barney
//
//  Created by Ryan Brainard on 7/29/14.
//  Copyright (c) 2014 Ryan Brainard. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var userEmail: NSTextField!
    @IBOutlet weak var appSelector: NSComboBox!
    
    var heroku: HerokuApi?
    
    @IBAction func setApiToken(sender: AnyObject) {
        if sender.stringValue != "" && (heroku?.token != sender.stringValue || !heroku?) {
            heroku = HerokuApi(token: sender.stringValue)
            refreshUserInfo()
            refreshAppList()
        }
    }
    
    func refreshUserInfo() {
        heroku?.account { account in
            self.userEmail.stringValue = account["email"] as String!
        }
    }
    
    func refreshAppList() {
        self.appSelector.removeAllItems()
        heroku?.apps { apps in
            for app in apps {
                self.appSelector.addItemWithObjectValue(app["name"])
            }
        }
    }
}

