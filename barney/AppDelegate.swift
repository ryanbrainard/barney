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
    @IBOutlet weak var sourceTextField: NSTextField!
    @IBOutlet weak var deployButton: NSButton!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var progressBarStatus: NSTextField!
    
    var state = State.Init
    var heroku: HerokuApi?
    var herokuAppName: String = ""
    var sourceUrl: NSURL?
    
    func applicationDidFinishLaunching(notification: NSNotification!) {
        println("init")
        deployButton.enabled = false
        render()
    }
    
    @IBAction func setApiToken(sender: AnyObject) {
        if sender.stringValue != "" && (heroku?.token != sender.stringValue || !heroku?) {
            heroku = HerokuApi(token: sender.stringValue)
            refreshUserInfo()
            refreshAppList()
        }
        render()
    }
    
    @IBAction func setAppName(sender: AnyObject) {
        println("herokuAppName: \(sender.stringValue)")
        herokuAppName = sender.stringValue
        render()
    }
    
    func setLocalSourceUrl(sourceUrl: NSURL) {
        println("sourceUrl: \(sourceUrl)")
        self.sourceUrl = sourceUrl
        self.sourceTextField.stringValue = sourceUrl.relativePath
        render()
    }
    
    @IBAction func deploy(sender: NSButton) {
        println("DEPLOY!")
        state = State.Deploying
        render()
        
        let hdrop = HDrop()
        let sourceStream = NSData(contentsOfURL: sourceUrl)
        hdrop.put(sourceStream)
    }
    
    func render() {
        if userEmail.stringValue != nil &&
            herokuAppName != nil &&
            sourceTextField.stringValue != nil {
                deployButton.enabled = true
        }
        
        progressBar.hidden = state == State.Init
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

