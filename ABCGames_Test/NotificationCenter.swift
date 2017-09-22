//
//  File.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/21/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation

class GameNotificationCenter{
    static func UpdateBonusPoints(points : Int){
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("Bonus Points"), object: nil, userInfo: ["points" : points])
    }
    
    static func UpdatePenaltyPoints(points : Int){
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("Penalty Points"), object: nil, userInfo: ["points" : points])
    }
    
    static func StartGame(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("Start Game"), object: nil, userInfo: nil)
    }

}
