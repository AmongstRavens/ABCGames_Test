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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
