//
//  VideoViewController.swift
//  KenyaNews
//
//  Created by Dominic Bett on 12/25/15.
//  Copyright © 2015 Dominic Bett. All rights reserved.
//

import Swift_YouTube_Player
import iAd

class VideoViewController: UIViewController, YouTubePlayerDelegate, ADBannerViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Reference to the AppDelegate
    
    
    var video: ChannelVideo = ChannelVideo()
    
    var expandedView = false
    
    @IBOutlet var videoPlayer: YouTubePlayerView! = YouTubePlayerView()
    @IBOutlet var lblTitle: UILabel! = UILabel()
    @IBOutlet var lblViews: UILabel! = UILabel()
    @IBOutlet var lblDate: UILabel! = UILabel()
    @IBOutlet var txtDescription: UITextView! = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Load  Video
        //self.videoPlayer.clear()
        videoPlayer.delegate = self
        self.videoPlayer.playerVars = ["playsinline": "1"]
        self.videoPlayer.loadVideoID(video.videoID)
        
        self.lblTitle.text = video.title
        self.lblViews.text = "👁 \(video.views)"
        self.lblDate.text = video.published
        self.txtDescription.text = video.summary
    }

    override func viewDidAppear(animated: Bool) {
        loadAds()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.appDelegate.adBannerView.removeFromSuperview()
        self.videoPlayer.removeFromSuperview()
    }
    
    func playerStateChanged(videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print("player state \(playerState)")
    }
    
    func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        print("plaback quality \(playbackQuality)")
        if videoPlayer.frame.origin == CGPointMake(0.0, 64.0) {
            expandedView = true
        }
        if expandedView {
            let frame = CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width * (195/320))
            self.videoPlayer.clear()
            self.videoPlayer.frame = frame
            self.videoPlayer.contentMode = UIViewContentMode.ScaleAspectFill
            self.view.addSubview(videoPlayer)
            expandedView = false
        }
    }
    
    func playerReady(videoPlayer: YouTubePlayerView) {
        print("ready to play")
        
        self.videoPlayer.play()
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
