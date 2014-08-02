//
//  HDrop.swift
//  barney
//
//  Created by Ryan Brainard on 7/31/14.
//  Copyright (c) 2014 Ryan Brainard. All rights reserved.
//

import Cocoa

class HDrop {
    let hdropUrl = NSURL(string: "https://hdrop.herokuapp.com")
    let verbose = true
    
    init() {}
    
    func upload(source: NSData, withGetUrl: (NSURL) -> Void) {
        withUrls { urls -> Void in
            let putUrl = NSURL(string: urls["put"] as String!)
            let request = NSMutableURLRequest(URL: putUrl)
            request.HTTPMethod = "PUT"
            request.HTTPBody = source
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(httpResponse, data, httpError) in
                if self.verbose {
                    println(httpResponse)
                    println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    println(httpError)
                }
                withGetUrl(NSURL(string: urls["get"] as String!))
            }
        }
    }
    
    private func withUrls<T>(action: (NSDictionary) -> T) {
        request(hdropUrl) { (urls: NSDictionary) in
            println("hdrop urls: \(urls)")
            action(urls)
        }
    }
    
    private func request<R>(url: NSURL, handler: (R) -> Void) {
        let request = NSMutableURLRequest(URL: url)
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(httpResponse, jsonData, httpError) in
            if self.verbose {
                println(httpResponse)
                println(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
                println(httpError)
            }
            
            var jsonError: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &jsonError) as R
            
            if self.verbose {
                println(json)
                println(jsonError)
            }
            
            handler(json)
        }
    }
}
