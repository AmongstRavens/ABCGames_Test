//
//  Score.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/20/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation

class Score{
    var bonusPoints : Int?
    var penaltyPoints : Int?
    var timestamp : TimeInterval?
    
    init(bonusPoints : Int, penaltyPoints : Int, totalTime : TimeInterval) {
        self.bonusPoints = bonusPoints
        self.penaltyPoints = penaltyPoints
        timestamp = totalTime
    }
}
