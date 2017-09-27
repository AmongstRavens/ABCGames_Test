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
    @IBOutlet weak var dimensionPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settupDimensionPicker()
        serverTimeSwitch.isOn = UserDefaults.standard.object(forKey: "Server Time") as? Bool ?? true
    }
    
    
    @IBAction func resetSettings(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "Server Time")
        serverTimeSwitch.isOn = true
        
        dimensionPicker.selectRow(5, inComponent: 0, animated: true)
        dimensionPicker.selectRow(5, inComponent: 1, animated: true)
        
        self.view.setNeedsDisplay()
        
    }
    
    @IBAction func applySettings(_ sender: UIButton) {
        UserDefaults.standard.set(serverTimeSwitch.isOn, forKey: "Server Time")
        let pickerIndexForXDimension = dimensionPicker.selectedRow(inComponent: 0)
        UserDefaults.standard.set(5 + pickerIndexForXDimension, forKey: "xDimension")
        
        let pickerIndexForYDimension = dimensionPicker.selectedRow(inComponent: 1)
        UserDefaults.standard.set(5 + pickerIndexForYDimension, forKey: "yDimension")
        
        //Access view via navigation controller stack
        if let mainVC = navigationController?.viewControllers[0] as? MainViewController{
            //Check if we should update UI
            if pickerIndexForXDimension + 5 != mainVC.gameFieldView.xDimension || pickerIndexForYDimension + 5 != mainVC.gameFieldView.yDimension{
                mainVC.gameFieldView.xDimension = 5 + pickerIndexForXDimension
                mainVC.gameFieldView.yDimension = 5 + pickerIndexForYDimension
                mainVC.gameFieldView.setNeedsDisplay()
            }
        }
        
        //Dismiss current view controller
        navigationController?.popViewController(animated: true)
    }
    
    private func settupDimensionPicker(){
        dimensionPicker.delegate = self
        dimensionPicker.dataSource = self
        var initialRowForXDimension =
            UserDefaults.standard.integer(forKey: "xDimension")
        var initialRowForYDimension = UserDefaults.standard.integer(forKey: "yDimension")
        
        if initialRowForXDimension == 0{
            //Default value
            initialRowForXDimension = 10
        }
        
        if initialRowForYDimension == 0{
            initialRowForYDimension = 10
        }
        
        dimensionPicker.selectRow(initialRowForXDimension - 5, inComponent: 0, animated: true)
        dimensionPicker.selectRow(initialRowForYDimension - 5, inComponent: 1, animated: true)
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
