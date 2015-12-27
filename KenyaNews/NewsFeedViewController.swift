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
    var _channels:[String:String] = ["NTV Kenya":"UCekTpzKodObpOcmvVCFUvTw", "KTN News":"UCKVsdeoHExltrWMuK0hOWmg", "K24 TV":"UCt3SE-Mvs3WwP7UW-PiFdqQ", "Citizen TV":"UChBQgieUidXV1CmDxSdRm3g", "KBC News":"UCypNjM5hP1qcUqQZe57jNfg", "Capital News":"UCsURxs8Kz_qzezpicj-STyw", "QTV Kenya": "UCqBJ47FjJcl61fmSbcadAVg", "Kass International":"UCBe0vbKt2uFu_4NeyZ7Uy1A", "Ebru Africa TV":"UCdYjYt4YGhEbCGMv1fbv0pg", "East Africa TV": "UCyYzMKBalg6jMVNuC-JRMog", "Family TV Kenya": "UCaezQJtBqkyuNFN8bGmBeMQ", "Pwani TV": "UCyNxk1YI_zf5sQjf-QSzYCg"]
    var currentChannel = "NTV Kenya"
    
    var vtitle:Bool = false
    var vsummary:Bool = false
    var vpublished:Bool = false
    var vID:Bool = false
    var _summary = ""
    var _title = ""
    
    var feeds = 10 // Limits number of feeds to 8
    
    var parser = NSXMLParser()
    var video = ChannelVideo()
    var videos = [ChannelVideo]()
    
    
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var btnRevealMenu: UIBarButtonItem!
    
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
                print("success loading!")
                
                // Sort by number of views
                videos = videos.sort({$0.views > $1.views})
            } else {
                print("parse failure!")
            }
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = Colors.white
        if let font = UIFont(name: "HelveticaNeue", size: 12) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Colors.white]
        }
    }

    
    //MARK: Parser start of element
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if feeds < 1 { return }
        
        if(elementName=="media:title" || elementName=="media:description" || elementName=="yt:videoId" || elementName=="published" || elementName=="media:thumbnail" || elementName == "media:statistics"){
            if(elementName=="media:title"){ vtitle = true }
            if(elementName=="media:description"){ vsummary = true }
            if(elementName=="published"){ vpublished = true }
            if(elementName=="yt:videoId"){ vID = true}
            if(elementName=="media:thumbnail") {
                imageForImageURLString(attributeDict["url"]!) { (image, success) -> Void in
                    if success {
                        self.video.thumbnail = image!
                    } else {
                        print("Error loading thumbnail image")
                    }
                }
            }
            if(elementName=="media:statistics") {
                self.video.views = Int(attributeDict["views"]!)!
                
                //Add video at the end of last element
                videos.append(video) // Appends at the end
                video = ChannelVideo()
                
                feeds -= 1
            }
        }
    }
    
    // MARK: Parser end of element
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName=="media:title" || elementName=="media:description" || elementName=="yt:videoId" || elementName=="published"){
            if(elementName=="media:title"){
                video.title = _title
                _title = ""
                vtitle = false
            }
            if(elementName=="media:description")
            {
                video.summary = _summary
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
        cell.imgThumbnail.layer.cornerRadius = 3.0
        cell.lblDate.text = data.published
        cell.lblViews.text = "\(data.views) Views"
        cell.lblTitle.text = data.title
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath: NSIndexPath = videosTableView.indexPathForSelectedRow {
            if let destVC:VideoViewController = segue.destinationViewController as? VideoViewController {
                destVC.video = videos[indexPath.row]
            }
        }
    }
    
}