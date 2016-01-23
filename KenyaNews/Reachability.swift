//
//  Reachability.swift
//  Kenya News
//
//  Created by Dominic Bett on 1/13/16.
//  Copyright © 2016 Dominic Bett. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    // Check if internet connection is available
    
    class func isConnectedToNetwork() -> Bool {
        
        var status:Bool = false
        
        let url = NSURL(string: "https://google.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response:NSURLResponse?
        
        do {
            let _ = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
           return status
    }
}