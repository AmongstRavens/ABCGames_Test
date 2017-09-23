//
//  GameField.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/20/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

@IBDesignable class GameField : UIView{
    var xDimension : Int = {
        let value : Int? = UserDefaults.standard.object(forKey: "xDimension") as? Int
        if let unwrappedValue = value{
            return unwrappedValue
        } else {
            //Defaut value
            return 10
        }
    }()
    var yDimension : Int = {
        let value : Int? = UserDefaults.standard.object(forKey: "yDimension") as? Int
        if let unwrappedValue = value{
            return unwrappedValue
        } else {
            //Default value
            return 10
        }
    }()
    
    private var subViewsHashTable = [String : UIView]()
    private var xOffset : CGFloat!
    private var yOffset : CGFloat!
    private var size : CGFloat!
    private var numberOfCapturedViews : Int = 0{
        didSet{
            if (numberOfCapturedViews % 5 == 0) && (numberOfCapturedViews != 0){
                bonusPoints += 1
            }
            
        }
    }
    private var bonusPoints : Int = 0{
        didSet{
            GameNotificationCenter.UpdateBonusPoints(points: bonusPoints)
        }
    }
    private var penaltyPoints : Int = 0{
        didSet{
            GameNotificationCenter.UpdatePenaltyPoints(points: penaltyPoints)
        }
    }
    private var previousSubviewForPanGesture : UIView?
    var isGameStarted : Bool = false {
        willSet{
            //To fix some bug
            if newValue == false{
                self.removeGestureRecognizer(panGestureRecognizer)
            }
        }
    }
    private var panGestureRecognizer : UIPanGestureRecognizer!
    
    
    //Initial settup
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:))))
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //Clear existing subviews and values
        resetGameField()
        
        self.addGestureRecognizer(panGestureRecognizer)
        //Create new ones
        createSubview()
    }
    
    private func createSubview(){
        if self.frame.width / CGFloat(xDimension) >= self.frame.height / CGFloat(yDimension){
            size = self.frame.height / CGFloat(yDimension)
            xOffset = (self.frame.width - size * CGFloat(xDimension)) / 2
            yOffset = 0
        } else {
            size = self.frame.width / CGFloat(xDimension)
            xOffset = 0
            yOffset = (self.frame.height - size * CGFloat(yDimension)) / 2
        }
        
        for row in 0..<xDimension{
            for column in 0..<yDimension{
                let origin = CGPoint(x: CGFloat(row) * size + xOffset, y: CGFloat(column) * size + yOffset)
                let subview = UIView(frame: CGRect(origin: origin, size: CGSize(width: size, height: size)))
                
                subview.backgroundColor = .red
                subview.layer.borderWidth = 1
                subview.layer.borderColor = UIColor.white.cgColor
                self.addSubview(subview)
                
                //Add subview in table for key : row | column
                subViewsHashTable["\(row)|\(column)"] = subview
                
            }
        }
    }
    
    private func resetGameField(){
        for (_, value) in subViewsHashTable{
            value.removeFromSuperview()
        }
        isGameStarted = false
        subViewsHashTable.removeAll()
        numberOfCapturedViews = 0
        bonusPoints = 0
        penaltyPoints = 0
    }
    
    
    //MARK: Gesture Recognizers Handlers
    
    @objc private func handleTapGesture(gesture: UITapGestureRecognizer){
        if !isGameStarted{
            GameNotificationCenter.StartGame()
            isGameStarted = true
        }
        
        let location = gesture.location(in: self)

        //Get row and column of current tap point
        let row = Int((location.x - xOffset) / size)
        let column = Int((location.y - yOffset) / size)
        let selectedSubview = subViewsHashTable["\(row)|\(column)"]
        if selectedSubview?.backgroundColor == .black{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            penaltyPoints += 1
        } else {
            selectedSubview?.backgroundColor = .black
        }
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer){
        if !isGameStarted{
            GameNotificationCenter.StartGame()
            isGameStarted = true
        }
        
        let location = gesture.location(in: self)
        //Get row and column of current tap point
        let row = Int((location.x - xOffset) / size)
        let column = Int((location.y - yOffset) / size)
        let selectedSubview = subViewsHashTable["\(row)|\(column)"]
        if selectedSubview != previousSubviewForPanGesture{
            previousSubviewForPanGesture = selectedSubview
            if selectedSubview?.backgroundColor == .black{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                penaltyPoints += 1
            } else {
                selectedSubview?.backgroundColor = .black
                numberOfCapturedViews += 1
            }
        }
        
        
        if gesture.state == .cancelled || gesture.state == .ended || gesture.state == .failed{
            numberOfCapturedViews = 0
        }
        
        
    }
}
