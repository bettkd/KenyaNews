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
    
    init(title:String, summary:String, published:String, thumbnail:UIImage, videoURL:String) {
        self.title = title
        self.summary = summary
        self.published = published
        self.thumbnail = thumbnail
        self.videoID = videoURL
    }
    
    override init() {
        title = ""
        summary = ""
        published = ""
        thumbnail = UIImage()
        videoID = ""
    }
}
