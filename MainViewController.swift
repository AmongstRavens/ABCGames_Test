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
            penaltyTimeLabel.isHidden = true
        }
    }
    @IBOutlet weak var bonusTimeLabel: UILabel!{
        didSet{
            bonusTimeLabel.isHidden = true
        }
    }
    private var timeSeconds : Int = 60
    private var timeMileseconds : Int = 60
    private var timer = Timer()
    
    
    //Redraw GameField when device rotated
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        gameFieldView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: Notification.Name("Player Interaction"), object: nil, queue: nil, using: catchNotification)
        notificationCenter.addObserver(forName: Notification.Name("Start Game"), object: nil, queue: nil, using: startGame)
    }
    
    private func catchNotification(notification: Notification){
        guard let userInfo = notification.userInfo,
            let bonusPoints  = userInfo["Bonus"] as? Int,
            let penaltyPoints = userInfo["Penalty"] as? Int else {
                print("No userInfo found in notification")
                return
        }
        
        bonusPointsLabel.text = "\(bonusPoints)"
        penaltyPointsLabel.text = "\(penaltyPoints)"
        
    }
    
    private func startGame(notification: Notification){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(MainViewController.stepper), userInfo: nil, repeats: true)
    }
    
    func stepper(){
        gameTimeLabel.text = "\(timeSeconds):\(timeMileseconds)"
        if timeSeconds == 0 && timeMileseconds == 0{
            timer.invalidate()
            finishGame()
            return
        }
        
        if timeMileseconds == 0{
            timeMileseconds = 60
            timeSeconds -= 1
        } else {
            timeMileseconds -= 1
        }
    }
    
    func finishGame(){
        //Update core data here
        //Show alert view result here
    }
}
