//
//  HerokuApi.swift
//  barney
//
//  Created by Ryan Brainard on 7/29/14.
//  Copyright (c) 2014 Ryan Brainard. All rights reserved.
//

import Cocoa

class HerokuApi {
    let baseUrl = NSURL(string: "https://api.heroku.com") // TODO: parameterize
    let token: String
    let verbose = false
    
    init(token: String) {
        self.token = token
    }
    
    func schema(handler: (NSDictionary) -> Void) {
        return request("/schema", handler)
    }
    
    func account(handler: (NSDictionary) -> Void) {
        return request("/account", handler)
    }
    
    func apps(handler: (NSArray) -> Void) {
        return requestArray("/apps", handler)
    }
    
    func builds(appName: String, handler: (NSDictionary) -> Void) {
        return request("/apps/\(appName)/builds", handler)
    }
    
    // TODO: hack until i figureout swift generics/covariance. unify with request() 
    private func requestArray(resource: String, handler: (NSArray) -> Void) {
        let url = baseUrl.URLByAppendingPathComponent(resource)
        let request = NSMutableURLRequest(URL: url)
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.setValue("application/vnd.heroku+json; version=3", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(httpResponse, jsonData, httpError) in
            if self.verbose {
                println(httpResponse)
                println(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
                println(httpError)
            }
            
            var jsonError: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &jsonError) as NSArray
            
            if self.verbose {
                println(json)
                println(jsonError)
            }
            
            handler(json)
        }
    }
    
    private func request(resource: String, handler: (NSDictionary) -> Void) {
        let url = baseUrl.URLByAppendingPathComponent(resource)
        let request = NSMutableURLRequest(URL: url)
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.setValue("application/vnd.heroku+json; version=3", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(httpResponse, jsonData, httpError) in
            if self.verbose {
                println(httpResponse)
                println(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
                println(httpError)
            }
            
            var jsonError: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &jsonError) as NSDictionary
            
            if self.verbose {
                println(json)
                println(jsonError)
            }
            
            handler(json)
        }
    }
}