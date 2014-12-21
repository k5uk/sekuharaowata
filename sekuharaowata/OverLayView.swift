//
//  OverLayView.swift
//  sekuharaowata
//
//  Created by Keisuke Ohta on 2014/11/08.
//  Copyright (c) 2014年 Keisuke Ohta. All rights reserved.
//

import Foundation
import UIKit

enum GGOverlayViewMode: Int {
    case Left
    case Right
}

class OverlayView: UIView {
    var mode: GGOverlayViewMode?
    var imageView: UIImageView = UIImageView()
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        imageView = UIImageView(image: UIImage(named: "noButton"))
        self.addSubview(imageView)
    }
    
    func setMode(mode: GGOverlayViewMode) {
        println("load setMode")
        
        println(mode)
        if mode == GGOverlayViewMode.Left {
            imageView.image = UIImage(named: "noButton")
        } else {
            imageView.image = UIImage(named: "yesButton")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectMake(50, 50, 100, 100)
        
    }
}