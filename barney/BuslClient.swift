//
//  BuslClient.swift
//  barney
//
//  Created by Ryan Brainard on 8/1/14.
//  Copyright (c) 2014 Ryan Brainard. All rights reserved.
//

import Cocoa

class BuslClient: NSObject, NSURLConnectionDataDelegate {
    
    let url: NSURL
    let handler: NSData -> Void
    
    init(url: NSURL, handler: NSData -> Void) {
        self.url = url
        self.handler = handler
    }
    
    func start() {
        let request = NSMutableURLRequest(URL: url)
        let responseData = NSMutableData(length: 0)
        println("STREAM BEFORE CONN")
        let connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        println("STREAM AFTER CONN")
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        println("didReceiveResponse")
        println(response)
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        println("didReceiveData")
        println(data)
        handler(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        println("connectionDidFinishLoading")
    }
}
