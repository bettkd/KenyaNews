//
//  ChannelVideo.swift
//  KE1
//
//  Created by Dominic Bett on 12/19/15.
//  Copyright © 2015 Dominic Bett. All rights reserved.
//

import UIKit

class ChannelVideo: NSObject {
    
    var title:String
    var summary:String
    var published:String
    var thumbnail:UIImage
    var videoID:String
    var views:Int
    
    init(title:String, summary:String, published:String, thumbnail:UIImage, videoURL:String, views:Int) {
        self.title = title
        self.summary = summary
        self.published = published
        self.thumbnail = thumbnail
        self.videoID = videoURL
        self.views = views
    }
    
    override init() {
        title = ""
        summary = ""
        published = ""
        thumbnail = UIImage()
        videoID = ""
        views = 0
    }
    
    //MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.summary = aDecoder.decodeObjectForKey("summary") as! String
        self.published = aDecoder.decodeObjectForKey("published") as! String
        self.thumbnail = aDecoder.decodeObjectForKey("thumbnail") as! UIImage
        self.videoID = aDecoder.decodeObjectForKey("videoID") as! String
        self.views = aDecoder.decodeObjectForKey("views") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(summary, forKey: "summary")
        aCoder.encodeObject(published, forKey: "published")
        aCoder.encodeObject(thumbnail, forKey: "thumbnail")
        aCoder.encodeObject(videoID, forKey: "videoID")
        aCoder.encodeObject(views, forKey: "views")
    }
}
