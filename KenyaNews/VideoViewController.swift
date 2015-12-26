//
//  VideoViewController.swift
//  KenyaNews
//
//  Created by Dominic Bett on 12/25/15.
//  Copyright © 2015 Dominic Bett. All rights reserved.
//

import Swift_YouTube_Player
import iAd

class VideoViewController: UIViewController, ADBannerViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Reference to the AppDelegate
    
    
    var video: ChannelVideo = ChannelVideo()
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblViews: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var txtDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Load  Video
        self.videoPlayer.playerVars = ["playsinline": "1"]
        self.videoPlayer.loadVideoID(video.videoID)
        self.videoPlayer.play()
        
        self.lblTitle.text = video.title
        self.lblViews.text = "👁 \(video.views)"
        self.lblDate.text = video.published
        self.txtDescription.text = video.summary
    }
    
    // MARK: Funtion to load iAds
    func loadAds(){
        self.appDelegate.adBannerView.removeFromSuperview()
        self.appDelegate.adBannerView.delegate = nil
        self.appDelegate.adBannerView = ADBannerView(frame: CGRect.zero)
        
        /* Puts the banner at the top
        self.appDelegate.adBannerView.center = CGPoint(x: view.bounds.width / 2, y: self.appDelegate.adBannerView.frame.height / 2)
        */
        
        // Puts the iAd banner at the bottom
        self.appDelegate.adBannerView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - self.appDelegate.adBannerView.frame.height / 2)
        
        self.appDelegate.adBannerView.delegate = self
        self.appDelegate.adBannerView.hidden = true
        view.addSubview(self.appDelegate.adBannerView)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.appDelegate.adBannerView.hidden = false
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        // Code
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.appDelegate.adBannerView.hidden = true
    }
}
