//
//  MainViewController.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/19/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit

@objcMembers
class MainViewController: UIViewController {
    
    @IBOutlet weak var serverTimeLabel: UILabel!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var gameFieldView: GameField!
    @IBOutlet weak var bonusPointsLabel: UILabel!
    @IBOutlet weak var penaltyPointsLabel: UILabel!
    @IBOutlet weak var penaltyTimeLabel: UILabel!{
        didSet{
            penaltyTimeLabel.alpha = 0
        }
    }
    @IBOutlet weak var bonusTimeLabel: UILabel!{
        didSet{
            bonusTimeLabel.alpha = 0
        }
    }
    private var timeSeconds : Int = 5
    private var timeMileseconds : Int = 0
    private var timer = Timer()
    private var serverTimetimer = Timer()
    private var totalTimeSeconds : Int = 0
    private var totalTimeMileseconds : Int = 0
    private var bonusPoints : Int = 0{
        didSet{
            bonusPointsLabel.text = "\(bonusPoints)"
            if bonusPoints != 0{
                flash(view: bonusTimeLabel)
            }
        }
    }
    private var penaltyPoints : Int = 0{
        didSet{
            penaltyPointsLabel.text = "\(penaltyPoints)"
            if penaltyPoints != 0{
                flash(view: penaltyTimeLabel)
            }
        }
    }
    private var timestamp : Double?{
        didSet{
            if timestamp != nil{
                updateClock(with: timestamp!)
            }
        }
    }
    private var isGameStarted : Bool = false
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        if !isGameStarted{
            performSegue(withIdentifier: "Show Settings View Controller", sender: sender)
        }
    }
    
    
    @IBAction func resultsButtonPressed(_ sender: UIBarButtonItem) {
        if !isGameStarted{
            performSegue(withIdentifier: "Show Results View Controller", sender: sender)
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
        getDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hide server time
        let sholudHideServerTime = UserDefaults.standard.object(forKey: "Server Time") as? Bool
        if sholudHideServerTime != nil {
            serverTimeLabel.isHidden = !sholudHideServerTime!
            serverTimeLabel.setNeedsDisplay()
        } else {
            serverTimeLabel.isHidden = false
            serverTimeLabel.setNeedsDisplay()
        }
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
        AppUtility.lockOrientation()
        isGameStarted = true
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MainViewController.stepper), userInfo: nil, repeats: true)
    }
    
    @objc func stepper(){
        if timeSeconds < 10{
            gameTimeLabel.text = "0\(timeSeconds):\(timeMileseconds)0"
        } else {
            gameTimeLabel.text = "\(timeSeconds):\(timeMileseconds)0"
        }
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
    
    @objc private func serverTimeTimerStepper(){
        timestamp! += 1000.0
    }
    
    private func finishGame(){
        isGameStarted = false
        timer.invalidate()
        //Add score into database
        ScoreViewModel.addScoreInCoreData(penaltyPoints: penaltyPoints, bonusPoints: bonusPoints, totalTime: "\(totalTimeSeconds):\(totalTimeMileseconds)0", serverTime: serverTimeLabel.text!)
        
        timeMileseconds = 0
        timeSeconds = 5
        gameFieldView.isGameStarted = false
        showResults()
        totalTimeSeconds = 0
        totalTimeMileseconds = 0
        
        //Redraw game field
        gameFieldView.setNeedsDisplay()
        AppUtility.unlockOrientation()
    }
    
    private func showResults(){
        let alertVC = UIAlertController(
            title: "Game Over",
            message: "Total Time : \n \(totalTimeSeconds):\(totalTimeMileseconds)0 \n Bonus Points: \(bonusPoints)\n Penalty Points : \(penaltyPoints)",
            preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertVC.addAction(doneAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    //Start clock timer
    private func updateClock(with timestamp: Double){
        let date = NSDate(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date as Date)
        serverTimeLabel.text = localDate
    }
    
    //Get server timestamp
    private func getDate(){
        let url = URL(string: "https://abcgames.khorost.net/api/?device=uuid22&ppa=zt_getInfo&app_version=1.5.0070&type=test&lang=ru")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil, error == nil else{
                print("Unable to get server time : \(String(describing: error?.localizedDescription))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Wrong status code : \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : Any]
                    if let timestamp = (json["data"] as! [String : Any])["timestamp"] as? Double{
                        self.timestamp = timestamp
                        //Run timer
                        self.serverTimetimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.serverTimeTimerStepper), userInfo: nil, repeats: true)
                    }
                    
                } catch{
                    print("Unable to parse data : \(error.localizedDescription)")
                }
            }
        }
        
        dataTask.resume()
        
    }
    
    func flash(view : UIView) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 0
        flash.toValue = 1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        view.layer.add(flash, forKey: nil)
    }
}
