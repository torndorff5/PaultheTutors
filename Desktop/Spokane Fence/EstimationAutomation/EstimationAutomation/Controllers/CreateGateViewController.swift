//
//  CreateGateViewController.swift
//  EstimationAutomation
//
//  Created by codeslinger on 5/29/19.
//  Copyright © 2019 SpokaneAutomationCompany. All rights reserved.
//

import UIKit

class CreateGateViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    var data:[String] = [String]()
    var loc:String?
    var len:Double?
    var index:Int = 1
    var tableIndex:Int?
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var length: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        data = ["Left Return", "Left Line", "Back Line", "Right Line", "Right Return"]
        length.text = "\(len ?? 0)"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
