//
//  CreateLineViewController.swift
//  EstimationAutomation
//
//  Created by codeslinger on 5/29/19.
//  Copyright © 2019 SpokaneAutomationCompany. All rights reserved.
//

import UIKit

class CreateLineViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    var data:[String] = [String]()
    var loc:String?
    var index:Int = 0
    var len:Double?
    var e:Bool?
    var b:Bool?
    var tableIndex:Int?
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var bti: UISwitch!
    @IBOutlet weak var eti: UISwitch!
    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        data = ["Left Return", "Left Line", "Back Line", "Right Line", "Right Return"]
        length.text = "\(len ?? 0)"
        bti.isOn = b ?? false
        eti.isOn = e ?? false
        picker.selectRow(data.firstIndex(of: loc ?? "") ?? 0, inComponent: 0, animated: true)
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //left line , right line, left return, right return, back line
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loc = data[row]
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
