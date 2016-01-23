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
    
    var feeds = 10 // Limits number of feeds to 10
    
    var parser = NSXMLParser()
    var video = ChannelVideo()
    var videos = [ChannelVideo]()
    
    
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var btnRevealMenu: UIBarButtonItem!
    @IBOutlet weak var _btnRecent: UIButton!
    @IBOutlet weak var _btnPopular: UIButton!
    var refreshControl:UIRefreshControl!
    var tableViewAnimation = "Automatic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = currentChannel
        
        videosTableView.delegate = self
        videosTableView.dataSource = self
        
        btnRevealMenu.target = self.revealViewController()
        btnRevealMenu.action = Selector("revealToggle:")

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        
        
        refresh(self, animation: tableViewAnimation)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = Colors.blue
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.videosTableView?.addSubview(self.refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let font:UIFont = UIFont(name: "HelveticaNeue", size: 12) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Colors.white]
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentTime = NSDate()
        var duration:Int = Int()
        
        if let prevTime = NSUserDefaults.standardUserDefaults().objectForKey("_time") as? NSDate {
            duration = NSCalendar.currentCalendar().components(.Minute, fromDate: prevTime, toDate: currentTime, options: []).minute
            NSUserDefaults.standardUserDefaults().setObject(currentTime, forKey: "_time")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            NSUserDefaults.standardUserDefaults().setObject(currentTime, forKey: "_time")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        // Refresh every five minutes
        if duration > 15 {
            refresh(self, animation: tableViewAnimation)
        }
    }
    
    func loadVideos(channel:String){
        url = urlRoot + _channels[channel]!
        
        if let urlToSend: NSURL = NSURL(string: url)! {
            
            // Parse the XML
            parser = NSXMLParser(contentsOfURL: urlToSend)!
            parser.delegate = self
            
            let success:Bool = parser.parse()
            
            if success {
                print("success loading!")
            } else {
                print("parse failure!")
            }
        }
    }
    
    func refresh(sender:AnyObject, animation:String){
        
        if Reachability.isConnectedToNetwork() {
            print("good to go")
        } else {
            print("Internet connection not available")
            
            let alert = UIAlertView(title: "No Internet connection", message: "Please ensure you are connected to the Internet", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        // Load in background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let myActivityIndicator = UIActivityIndicatorView( activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            myActivityIndicator.center = self.view.center
            myActivityIndicator.startAnimating()
            self.view.addSubview(myActivityIndicator)
            
            self.loadVideos(self.currentChannel)
            
            dispatch_async(dispatch_get_main_queue()) {
                //self.videosTableView.reloadData()
                let range = NSMakeRange(0, self.videosTableView.numberOfSections)
                let sections = NSIndexSet(indexesInRange: range)
                if animation == "Right" {
                    self.videosTableView.reloadSections(sections, withRowAnimation: .Right)
                } else if animation == "Automatic" {
                    self.videosTableView.reloadSections(sections, withRowAnimation: .Automatic)
                }
                
                myActivityIndicator.stopAnimating()
                
                //self.videosTableView.separatorStyle = .SingleLine
            }
        }
        self.refreshControl?.endRefreshing()
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        tableViewAnimation = "Automatic"
        refresh(self, animation: tableViewAnimation)
        refreshControl.endRefreshing()
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
        return videos.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewsFeedTableViewCell
        
        let data = videos[indexPath.row]
        
        cell.imgThumbnail.layer.cornerRadius = 3.0
        cell.imgThumbnail.image = data.thumbnail
        
        let currentTime = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        let published = dateFormatter.dateFromString(data.published)
        let duration = NSCalendar.currentCalendar().components(.Day, fromDate: published!, toDate: currentTime, options: []).day
        var day:String
        if duration == 0 { day = "Today" }
        else if duration == 1 { day = "Yesterday"}
        else { day = "\(duration) days ago"}
        cell.lblDate.text = day
        cell.lblViews.text = "\(data.views) views"
        cell.lblTitle.text = data.title
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
    }
    
    // SEGUE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath: NSIndexPath = videosTableView.indexPathForSelectedRow {
            if let destVC:VideoViewController = segue.destinationViewController as? VideoViewController {
                destVC.video = videos[indexPath.row]
            }
        }
    }

    // BUTTONS
    @IBAction func btnRecent(sender: AnyObject) {
        videos = videos.sort({$0.published > $1.published})
        videosTableView.reloadData()
        self._btnRecent.alpha = 0.8
        self._btnPopular.alpha = 1.0
    }
    
    @IBAction func btnPopular(sender: AnyObject) {
        videos = videos.sort({$0.views > $1.views})
        videosTableView.reloadData()
        self._btnRecent.alpha = 1.0
        self._btnPopular.alpha = 0.8
    }
    
}