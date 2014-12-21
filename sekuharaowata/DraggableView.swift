//
//  CardViewController.swift
//  sekuharaowata
//
//  Created by Keisuke Ohta on 2014/11/08.
//  Copyright (c) 2014年 Keisuke Ohta. All rights reserved.
//

import Foundation
import UIKit

let kActionMargin = 120
let kScaleStrength = 4
let kScaleMax = 0.93
let kRotationMax = 1
let kRotationStrength = 320
let kRotationAngle = M_PI/8

// 後に出てくるDraggableViewBackground.swiftで使用する。カードが左右にスワイプされたときのアクションのためのプロトコル。

protocol DraggableViewDelegate {
    func cardSwipedLeft(card: UIView)
    func cardSwipedRight(card: UIView)
}


class DraggableView: UIView {
    var delegate: DraggableViewDelegate?
    var information: UILabel = UILabel()
    var overlayView: OverlayView?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originaiPoint: CGPoint = CGPoint()
    var xFromCenter: CGFloat = CGFloat()
    var yFromCenter: CGFloat = CGFloat()
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        information = UILabel(frame:CGRectMake(0, 50, self.frame.size.width, 100))
        information.text = "no info given"
        information.textAlignment = NSTextAlignment.Center
        information.textColor = UIColor.blackColor()
        self.backgroundColor = UIColor.blackColor()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("beingDragged:"))
        self.addGestureRecognizer(panGestureRecognizer!)
        self.addSubview(information)
        overlayView = OverlayView(frame: CGRectMake(self.frame.size.width/2-100, 0, 100, 100))
        overlayView!.alpha = 0
        self.addSubview(overlayView!)
        
    }
    
    func setupView() {
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        var xFromCenter = gestureRecognizer.translationInView(self).x
        var yFromCenter = gestureRecognizer.translationInView(self).y
        
        switch (gestureRecognizer.state) {
            
            case UIGestureRecognizerState.Began:
                self.originaiPoint = self.center;
                break;
            
            case UIGestureRecognizerState.Changed:
                var rotationStrength: CGFloat = min(xFromCenter / CGFloat(kRotationStrength), CGFloat(kRotationMax))
                var rotationAngle: CGFloat = CGFloat(kRotationAngle) * rotationStrength
                var scale: CGFloat = max(1 - CGFloat(fabsf(Float(rotationStrength))) / CGFloat(kScaleStrength), CGFloat(kScaleMax))
                self.center = CGPointMake(self.originaiPoint.x + xFromCenter, self.originaiPoint.y + yFromCenter)
                var transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
                var scaleTransfrom: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
                self.transform = scaleTransfrom
                self.updateOverlay(xFromCenter)
                break
            
            case UIGestureRecognizerState.Ended:
                self.afterSwipeAction(xFromCenter)
                break
                
            case UIGestureRecognizerState.Possible:
                break
                
            case UIGestureRecognizerState.Cancelled:
                break
                
            case UIGestureRecognizerState.Failed:
                break
            
        }
    }
    
    func updateOverlay(distance: CGFloat) {
        if distance > 0 {
            overlayView!.setMode(GGOverlayViewMode.Right)
        } else {
            overlayView!.setMode(GGOverlayViewMode.Left)
        }
        
        overlayView!.alpha = min(CGFloat(fabsf(Float(distance))/100), 0.4)
    }
    
    func afterSwipeAction(xFromCenter: CGFloat) {
        if xFromCenter > CGFloat(kActionMargin) {
            self.rightAction()
        } else if xFromCenter < CGFloat(-kActionMargin) {
            self.leftAction()
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.center = self.originaiPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView!.alpha = 0
            })
        }
    }
    
    func rightAction() {
        var finishPoint: CGPoint = CGPointMake(500, 2 * yFromCenter + self.originaiPoint.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            }, completion: {
                (value: Bool) in self.removeFromSuperview()
        })
        delegate?.cardSwipedRight(self)
        NSLog("YES")
    }
    
    func leftAction() {
        var finishPoint: CGPoint = CGPointMake(-500, 2 * yFromCenter + self.originaiPoint.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            }, completion: {
                (value: Bool) in self.removeFromSuperview()
        })
        delegate?.cardSwipedLeft(self)
        NSLog("NO")
    }
    
    func rightClickAction() {
        var finishPoint: CGPoint = CGPointMake(600, self.center.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in self.removeFromSuperview()
        })
        delegate?.cardSwipedRight(self)
        NSLog("YES")
    }
    
    func leftClickAction() {
        var finishPoint: CGPoint = CGPointMake(-600, self.center.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in self.removeFromSuperview()
        })
        delegate?.cardSwipedRight(self)
        NSLog("NO")
    }
    
    
    
    
}