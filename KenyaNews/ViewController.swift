//
//  ViewController.swift
//  SBLoader
//
//  Created by Satraj Bambra on 2015-03-16.
//  Copyright (c) 2015 Satraj Bambra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HolderViewDelegate {
  
  var holderView = HolderView(frame: CGRectZero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    addHolderView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func addHolderView() {
    let boxSize: CGFloat = 100.0
    holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                              y: view.bounds.height / 2 - boxSize / 2,
                              width: boxSize,
                              height: boxSize)
    holderView.parentFrame = view.frame
    holderView.delegate = self
    view.addSubview(holderView)
    holderView.addOval()
  }
  
  func animateLabel() {
    // 1
    holderView.removeFromSuperview()
    view.backgroundColor = Colors.blue

    // 2
    let screen = UIScreen.mainScreen().bounds
    let lblWelcome: UILabel = UILabel(frame: CGRectMake(0,0,screen.width,50))
    lblWelcome.center = CGPointMake(screen.width/2, screen.height/2 - 50)
    lblWelcome.textColor = Colors.white
    lblWelcome.font = UIFont(name: "HelveticaNeue-Thin", size: 48.0)
    lblWelcome.textAlignment = NSTextAlignment.Center
    lblWelcome.text = "Kenya News"
    //label.sizeToFit()
    lblWelcome.transform = CGAffineTransformScale(lblWelcome.transform, 0.25, 0.25)
    view.addSubview(lblWelcome)

    // 3
    UIView.animateWithDuration(1.0, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
      animations: ({
        lblWelcome.transform = CGAffineTransformScale(lblWelcome.transform, 4.0, 4.0)
      }), completion: { finished in
        self.addButton()
    })
    
    // 4
    let lblTap: UILabel = UILabel(frame: CGRectMake(0,0,screen.width,50))
    lblTap.center = CGPointMake(screen.width/2, screen.height/2 + 50)
    lblTap.textColor = Colors.white
    lblTap.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
    lblTap.textAlignment = NSTextAlignment.Center
    lblTap.text = "Tap anywhere to continue.."
    //lblTap.transform = CGAffineTransformScale(lblWelcome.transform, 0.25, 0.25)
    view.addSubview(lblTap)
  }
  
  func addButton() {
    let button = UIButton()
    button.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
    button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    view.addSubview(button)
  }
  
  func buttonPressed(sender: UIButton!) {
    
    view.backgroundColor = Colors.blue
    self.performSegueWithIdentifier("openApp", sender: self)
    //view.subviews.map({ $0.removeFromSuperview() })
    //holderView = HolderView(frame: CGRectZero)
    //addHolderView()
  }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let myActivityIndicator = UIActivityIndicatorView( activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
    }
}

