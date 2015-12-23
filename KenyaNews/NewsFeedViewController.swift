//
//  NewsFeedViewController.swift
//  KenyaNews
//
//  Created by Dominic Bett on 12/21/15.
//  Copyright © 2015 Dominic Bett. All rights reserved.
//

import UIKit

import Swift_YouTube_Player

class NewsFeedViewController: UIViewController, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var url:String!
    let urlRoot:String="https://www.youtube.com/feeds/videos.xml?channel_id="
    var _channels:[String:String] = ["NTV Kenya" : "UCekTpzKodObpOcmvVCFUvTw", "KTN News": "UCKVsdeoHExltrWMuK0hOWmg", "K24 TV": "UCt3SE-Mvs3WwP7UW-PiFdqQ", "Citizen TV": "UChBQgieUidXV1CmDxSdRm3g", "KBC News": "UCypNjM5hP1qcUqQZe57jNfg"]
    var currentChannel = "NTV Kenya"
    
    var vtitle:Bool = false
    var vsummary:Bool = false
    var vpublished:Bool = false
    var vID:Bool = false
    var _summary = ""
    var _title = ""
    
    var parser = NSXMLParser()
    var video = ChannelVideo()
    var videos = [ChannelVideo]()
    
    
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var btnRevealMenu: UIBarButtonItem!
    @IBOutlet var videoPlayer: YouTubePlayerView!
    //let playerFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.mainScreen().bounds.size)
    //var videoPlayer:YouTubePlayerView = YouTubePlayerView(playerFrame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentChannel
        
        videosTableView.delegate = self
        videosTableView.dataSource = self
        
        btnRevealMenu.target = self.revealViewController()
        btnRevealMenu.action = Selector("revealToggle:")

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        url = urlRoot + _channels[currentChannel]!
        
        if let urlToSend: NSURL = NSURL(string: url)! {
            
            // Parse the XML
            parser = NSXMLParser(contentsOfURL: urlToSend)!
            parser.delegate = self
            
            let success:Bool = parser.parse()
            
            if success {
                print("parse success!")
            } else {
                print("parse failure!")
            }
        }

        
        self.videoPlayer.playerVars = ["playsinline": "1"]
        videoPlayer.loadVideoID(videos[0].videoID)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: Parser start of element
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName=="media:title" || elementName=="media:description" || elementName=="yt:videoId" || elementName=="published" || elementName=="media:thumbnail"){
            if(elementName=="media:title"){ vtitle = true }
            if(elementName=="media:description"){ vsummary = true }
            if(elementName=="published"){ vpublished = true }
            if(elementName=="yt:videoId"){ vID = true}
            if(elementName=="media:thumbnail")
            {
                imageForImageURLString(attributeDict["url"]!) { (image, success) -> Void in
                    if success {
                        self.video.thumbnail = image!
                    } else {
                        print("Error loading thumbnail image")
                    }
                }
            }
        }
    }
    
    // MARK: Parser end of element
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName=="media:title" || elementName=="media:description" || elementName=="yt:videoId" || elementName=="published" || elementName=="media:thumbnail"){
            if(elementName=="media:title"){
                video.title = _title
                _title = ""
                vtitle = false
            }
            if(elementName=="media:description")
            {
                //Add video at the end
                video.summary = _summary
                videos.append(video) // Appends at the end
                video = ChannelVideo()
                _summary = ""
                vsummary = false
            }
            if(elementName=="published"){ vpublished = false }
            if(elementName=="yt:videoId"){ vID = false}
        }
    }
    
    // MARK: Parser found items
    func parser(parser: NSXMLParser, foundCharacters data: String) {
        if(vID){
            video.videoID = data
            //print (data)
        }
        if (vtitle){
            _title += data
        }
        if(vsummary){
            //var data = data.stringByReplacingOccurrencesOfString("\\n", withString: "")
            //let data = data.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            //print(data)
            _summary += data
        }
        if(vpublished){
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.dateFromString(data)
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .MediumStyle
            let _date = dateFormatter.stringFromDate(date!)
            self.video.published = _date
        }
    }
    
    // MARK: Parser Error
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
    }
    
    // MARK: Load image from url
    func imageForImageURLString(imageURLString: String, completion: (image: UIImage?, success: Bool) -> Void) {
        guard let url = NSURL(string: imageURLString),
            let data = NSData(contentsOfURL: url),
            let image = UIImage(data: data)
            else {
                completion(image: nil, success: false);
                return
        }
        
        completion(image: image, success: true)
    }
    
    
    // MARK: Table View render ---
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(videos.count)
        return videos.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewsFeedTableViewCell
        
        let data:ChannelVideo = videos[indexPath.row]
        
        cell.imgThumbnail.image = data.thumbnail
        cell.lblDate.text = data.published
        cell.lblTitle.text = data.title
        cell.txtDescription.text = data.summary
        
        cell.btnPlayVideo.tag = indexPath.row
        cell.btnPlayVideo.addTarget(self, action: "playVideo:", forControlEvents: .TouchUpInside)
        
        
        return cell
    }
    
    @IBAction func playVideo(sender: UIButton){
        let video:ChannelVideo = videos[sender.tag]
        
        // Load video from YouTube ID
        self.videoPlayer.playerVars = ["playsinline": "1"]
        self.videoPlayer.loadVideoID(video.videoID)
    }
    
}