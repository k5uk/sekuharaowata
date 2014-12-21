//
//  DraggableViewBackground.swift
//  sekuharaowata
//
//  Created by Keisuke Ohta on 2014/11/08.
//  Copyright (c) 2014年 Keisuke Ohta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DraggableViewBackground: UIView, DraggableViewDelegate {
    var cardsLoadedIndex:Int = Int()
    var loadedCards: NSMutableArray = NSMutableArray()
    var menuButton: UIBarButtonItem = UIBarButtonItem()
    var outButton: UIButton = UIButton()
    var safeButton: UIButton = UIButton()
    var navBar: UINavigationBar = UINavigationBar()
    
    let kMaxBufferSize: Int = 2
    let kCardHeight: CGFloat = 260
    let kCardWidth: CGFloat = 260
    
    var exampleCardLabels: NSArray = NSArray()
    var allCards: NSMutableArray = NSMutableArray()
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        
//        var gotData = Alamofire.request(.GET, "https://haraaassment.herokuapp.com/posts").responseString { (_, _, string, _) in
//            println(string)
//        }
    
        
////        var gotDataStr = String(gotData)
//        var gotDataStr = ""
//        gotDataStr.extend(gotData)
//        
//        var gotDataArray: String[]! = gotData.componentsSeparatedByString("\"")
//        println(gotDataArray)
        
 
        exampleCardLabels = ["新卒の女の子に「このアドレスの意味って何？って聞いたら秘密です」って言われました。これってセクハラになりますか", "もちろんなります", "当たり前だボケ", "ググレカス"]
        loadedCards = []
        cardsLoadedIndex = 0
        self.loadCards()
    }
    
    func setupView() {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1.0);
        navBar = UINavigationBar(frame: CGRectMake(0, 0, 350, 20))
//        menuButton = UIBarButtonItem(image: menuButtonImage, style: Plain, target: self, action: "menuButtonTapped")
//        menuButton = UIBarButtonItem(image: UIimage(named: "menuButton"), style: UIBarButtonItemStyle.Plain, target: self, action: "menuButtontapped")
        outButton = UIButton(frame:CGRectMake(60,485,59,59))
        safeButton = UIButton(frame:CGRectMake(200,485,59,59));
        let menuButtonImage = UIImage(named: "menuButton")
        let outButtonImage = UIImage(named: "outButton")
        let safeButtonImage = UIImage(named: "safeButton")
//        menuButton.setImage(menuButtonImage, forState: UIControlState.Normal)
        outButton.setImage(outButtonImage, forState: UIControlState.Normal)
        safeButton.setImage(safeButtonImage, forState: UIControlState.Normal)
        outButton.addTarget(self, action: "swipeLeft", forControlEvents: .TouchUpInside)
        safeButton.addTarget(self, action: "swipeRight", forControlEvents: .TouchUpInside)
//        self.addSubview(menuButton)
        self.addSubview(outButton)
        self.addSubview(safeButton)
    }
    
    func menuButtonTapped(segue:UIStoryboardSegue) {
        
    }
    
    func createDraggableViewWithDataAtIndex(index: Int) ->DraggableView {
        var draggableView: DraggableView = DraggableView(frame: CGRectMake(30, 100, kCardWidth, kCardHeight))
        draggableView.information.text = exampleCardLabels.objectAtIndex(index) as String
        draggableView.backgroundColor = UIColor.whiteColor()
        draggableView.delegate = self
        return draggableView
    }
    
    func loadCards() {
        if (exampleCardLabels.count > 0) {
            var numLoadedCardsCap = ((exampleCardLabels.count > kMaxBufferSize) ? kMaxBufferSize : exampleCardLabels.count )
            for i in 0..<exampleCardLabels.count {
                var newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.addObject(newCard)
                if (i < numLoadedCardsCap) {
                    loadedCards.addObject(newCard)
                }
            }
            
            for i in 0..<loadedCards.count {
                if (i > 0) {
                    self.insertSubview(loadedCards.objectAtIndex(i) as UIView, belowSubview: loadedCards.objectAtIndex(i-1) as UIView)
                } else {
                    self.addSubview(loadedCards.objectAtIndex(i) as UIView)
                }
                cardsLoadedIndex++
            }
        }
    }
    
    func cardSwipedLeft(card: UIView) {
        loadedCards.removeObjectAtIndex(0)
        if ( cardsLoadedIndex < allCards.count ) {
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++
            self.insertSubview(loadedCards.objectAtIndex(kMaxBufferSize-1) as UIView, belowSubview: loadedCards.objectAtIndex(kMaxBufferSize-2) as UIView)
        }
    }
    
    func cardSwipedRight(card: UIView) {
        loadedCards.removeObjectAtIndex(0)
        if ( cardsLoadedIndex < allCards.count ) {
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++
            self.insertSubview(loadedCards.objectAtIndex(kMaxBufferSize-1) as UIView, belowSubview: loadedCards.objectAtIndex(kMaxBufferSize-2) as UIView)
        }
    }
    
    func swipeRight() {
        var dragView: DraggableView = loadedCards.firstObject as DraggableView
        dragView.overlayView!.mode = GGOverlayViewMode.Right
        UIView.animateWithDuration(0.2, animations: {
            dragView.overlayView!.alpha = 1
        })
        dragView.rightClickAction()
    }
    
    func swipeLeft() {
        var dragView: DraggableView = loadedCards.firstObject as DraggableView
        dragView.overlayView!.mode = GGOverlayViewMode.Left
        UIView.animateWithDuration(0.2, animations: {
            dragView.overlayView!.alpha = 1
        })
        dragView.leftClickAction()
    }
}