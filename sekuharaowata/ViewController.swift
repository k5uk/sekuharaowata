//
//  ViewController.swift
//  sekuharaowata
//
//  Created by Keisuke Ohta on 2014/11/07.
//  Copyright (c) 2014年 Keisuke Ohta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    @IBOutlet weak var topImage: UIImageView!
//    @IBOutlet weak var postButton: UIButton!
//    @IBOutlet weak var viewButton: UIButton!
    
    override func viewDidLoad() {
        var draggableBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func viewButtonTapped(AnyObject) {
//        var draggableBackground = DraggableViewBackground(frame: self.view.frame)
//        self.view.addSubview(draggableBackground)
//    }


}

