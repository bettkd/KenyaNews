//
//  RectangleLayer.swift
//  SBLoader
//
//  Created by Satraj Bambra on 2015-03-20.
//  Copyright (c) 2015 Satraj Bambra. All rights reserved.
//

import UIKit

class RectangleLayer: CAShapeLayer {
  
  override init() {
    super.init()
    fillColor = Colors.clear.CGColor
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func animateStrokeWithColor(color: UIColor) {
    strokeColor = color.CGColor
    let strokeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeAnimation.fromValue = 0.0
    strokeAnimation.toValue = 1.0
    strokeAnimation.duration = 0.2
    addAnimation(strokeAnimation, forKey: nil)
  }
}
