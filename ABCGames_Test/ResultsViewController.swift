//
//  ResultsViewController.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/20/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var scoreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
    }
}

//MARK : UITableViewDelegate/DataSource
extension ResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Score Cell", for: indexPath) as! ScoreTableViewCell
        cell.bonusPointsLabel.text = "10"
        cell.penaltyPointsLabel.text = "10"
        cell.serverTimeLabel.text = "20:20"
        cell.totalTimeLabel.text = "00:20"
        return cell
    }
}

class ScoreTableViewCell : UITableViewCell{

    @IBOutlet weak var serverTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var penaltyPointsLabel: UILabel!
    @IBOutlet weak var bonusPointsLabel: UILabel!
}
