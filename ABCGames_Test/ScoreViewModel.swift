//
//  ScoreViewModel.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/21/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ScoreViewModel{
    static let coreDataStack = CoreDataStack()
    
    static func addScoreInCoreData(penaltyPoints: Int, bonusPoints: Int, totalTime: String, serverTime: String){
        let scoreData = NSEntityDescription.insertNewObject(forEntityName: "Score", into: coreDataStack.managedObjectContext) as! Score
        scoreData.bonusPoints = Int16(bonusPoints)
        scoreData.penaltyPoints = Int16(penaltyPoints)
        scoreData.serverTime = serverTime
        scoreData.totalTime = totalTime
        
        do{
            try coreDataStack.managedObjectContext.save()
        } catch {
            fatalError("Failed to save managed context : \(error)")
        }
    }
    
    static func fetchEntitiesFromDatabase() -> [Score]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        do{
            let fetchedScores = try coreDataStack.managedObjectContext.fetch(fetchRequest) as! [Score]
            return fetchedScores
        } catch{
            fatalError("Unable to access managed object : \(error)")
        }
        return nil
    }
}
