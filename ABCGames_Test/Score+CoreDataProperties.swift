//
//  Score+CoreDataProperties.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/22/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var bonusPoints: Int16
    @NSManaged public var penaltyPoints: Int16
    @NSManaged public var serverTime: String?
    @NSManaged public var totalTime: String?

}
