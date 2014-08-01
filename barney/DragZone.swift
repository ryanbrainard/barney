//
//  DragZone.swift
//  barney
//
//  Created by Ryan Brainard on 7/30/14.
//  Copyright (c) 2014 Ryan Brainard. All rights reserved.
//

import Cocoa

class DragZone: NSView, NSDraggingDestination {
    
    init(frame: NSRect) {
        super.init(frame: frame)
        registerForDraggedTypes([NSURLPboardType])
    }

    override func draggingEntered(sender: NSDraggingInfo!) -> NSDragOperation  {
        println("draggingEntered: \(sender)")
        return NSDragOperation.All
    }
    
    override func performDragOperation(sender: NSDraggingInfo!) -> Bool {
        println("draggingPerformed: \(sender)")
        let pboard = sender.draggingPasteboard()
        let url = NSURL.URLFromPasteboard(pboard)
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        // TODO: check if file is of correct type
        appDelegate.setLocalSourceUrl(NSURL.URLFromPasteboard(pboard))
        return true
    }
}