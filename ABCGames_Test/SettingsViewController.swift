//
//  SettingsViewController.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/20/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController{

    @IBOutlet weak var serverTimeSwitch: UISwitch!
    @IBOutlet weak var gridSwitch: UISwitch!
    @IBOutlet weak var dimensionPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dimensionPicker.delegate = self
        dimensionPicker.dataSource = self
    }
    
    
    @IBAction func resetSettings(_ sender: UIButton) {
    }
    
    @IBAction func applySettings(_ sender: UIButton) {
    }
    
}


//MARK: UIPickerViewDelegate/DataSource
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 5)
    }
}
