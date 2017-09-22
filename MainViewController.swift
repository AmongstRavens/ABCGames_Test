//
//  MainViewController.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/19/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var serverTimeLabel: UILabel!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var gameFieldView: GameField!
    @IBOutlet weak var bonusPointsLabel: UILabel!
    @IBOutlet weak var penaltyPointsLabel: UILabel!
    @IBOutlet weak var penaltyTimeLabel: UILabel!{
        didSet{
            penaltyTimeLabel.textColor = .white
        }
    }
    @IBOutlet weak var bonusTimeLabel: UILabel!{
        didSet{
            bonusTimeLabel.textColor = .white
        }
    }
    private var timeSeconds : Int = 5
    private var timeMileseconds : Int = 0
    private var timer = Timer()
    private var totalTimeSeconds : Int = 0
    private var totalTimeMileseconds : Int = 0
    private var bonusPoints : Int = 0{
        didSet{
            bonusPointsLabel.text = "\(bonusPoints)"
        }
    }
    private var penaltyPoints : Int = 0{
        didSet{
            penaltyPointsLabel.text = "\(penaltyPoints)"
        }
    }
    
    
    //Redraw GameField when device rotated
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        gameFieldView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: Notification.Name("Bonus Points"), object: nil, queue: nil, using: catchBonusPointsNotification)
        notificationCenter.addObserver(forName: Notification.Name("Penalty Points"), object: nil, queue: nil, using: catchPenaltyPointsNotification)
        notificationCenter.addObserver(forName: Notification.Name("Start Game"), object: nil, queue: nil, using: startGame)
    }
    
    private func catchBonusPointsNotification(notification: Notification){
        guard let userInfo = notification.userInfo,
            let bonusPoints  = userInfo["points"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        
        self.bonusPoints = bonusPoints
        
        if bonusPoints != 0{
            timeSeconds += 1
        }
        
    }
    
    private func catchPenaltyPointsNotification(notification: Notification){
        guard let userInfo = notification.userInfo,
            let penaltyPoints  = userInfo["points"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        
        self.penaltyPoints = penaltyPoints
        
        if penaltyPoints != 0{
            //Decrease timer
            if timeSeconds == 0{
                timeMileseconds = 0
            } else {
                timeSeconds -= 1
            }
        }
        
    }
    
    private func startGame(notification: Notification){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MainViewController.stepper), userInfo: nil, repeats: true)
    }
    
    func stepper(){
        gameTimeLabel.text = "\(timeSeconds):\(timeMileseconds)"
        if timeSeconds == 0 && timeMileseconds == 0{
            finishGame()
            return
        }
        
        //Decrease timer
        if timeMileseconds == 0{
            timeMileseconds = 9
            timeSeconds -= 1
        } else {
            timeMileseconds -= 1
        }
        
        //Increse total time
        if totalTimeMileseconds == 9{
            totalTimeSeconds += 1
            totalTimeMileseconds = 0
        } else {
            totalTimeMileseconds += 1
        }
    }
    
    private func finishGame(){
        timer.invalidate()
        //Add score into database
        ScoreViewModel.addScoreInCoreData(penaltyPoints: penaltyPoints, bonusPoints: bonusPoints, totalTime: "\(totalTimeSeconds):\(totalTimeMileseconds)0", serverTime: "")
        
        timeMileseconds = 0
        timeSeconds = 5
        gameFieldView.isGameStarted = false
        showResults()
        totalTimeSeconds = 0
        totalTimeMileseconds = 0
        
        //Redraw game field
        gameFieldView.setNeedsDisplay()
    }
    
    private func showResults(){
        let alertVC = UIAlertController(title: "Game Over", message: "Total Time : \n \(totalTimeSeconds):\(totalTimeMileseconds)0", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertVC.addAction(doneAction)
        present(alertVC, animated: true, completion: nil)
    }

}
