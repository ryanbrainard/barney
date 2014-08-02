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
    let verbose = true
    
    init(token: String) {
        self.token = token
    }
    
    func schema(handler: (NSDictionary) -> Void) {
        request("/schema", handler)
    }
    
    func account(handler: (NSDictionary) -> Void) {
        request("/account", handler)
    }
    
    func apps(handler: (NSArray) -> Void) {
        request("/apps", handler)
    }
    
    func build(appName: String, sourceBlobUrl: NSURL, handler: (NSDictionary) -> Void) {
        request("/apps/\(appName)/builds", method: "POST", body: ["source_blob": ["url": sourceBlobUrl.absoluteString]], handler)
    }
    
    private func request<R>(resource: String, handler: (R) -> Void) {
        request(resource, method: "GET", body: nil, handler)
    }
    
    private func request<R>(resource: String, method: String, body: Dictionary<String,NSObject>?, handler: (R) -> Void) {
        let url = baseUrl.URLByAppendingPathComponent(resource)
        let request = NSMutableURLRequest(URL: url)
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.HTTPMethod = method
        if resource.hasSuffix("builds") {
            request.setValue("application/vnd.heroku+json; version=edge", forHTTPHeaderField: "Accept")
        } else {
            request.setValue("application/vnd.heroku+json; version=3", forHTTPHeaderField: "Accept")
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if body? {
            var reqJsonError: NSError?
            let jsonBody = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &reqJsonError)
            if self.verbose {
                println(jsonBody)
                println(reqJsonError)
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = jsonBody
        }
        
        if self.verbose {
            println(request)
        }
        
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