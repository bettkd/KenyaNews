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
}
