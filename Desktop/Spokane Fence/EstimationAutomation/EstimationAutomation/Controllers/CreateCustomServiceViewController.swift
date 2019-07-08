//
//  CreateCustomServiceViewController.swift
//  EstimationAutomation
//
//  Created by codeslinger on 6/13/19.
//  Copyright © 2019 SpokaneAutomationCompany. All rights reserved.
//

import UIKit

class CreateCustomServiceViewController: UIViewController {


    var item:Lines?
    var saleItem:SaleItemLineDetail?
    var desc: String = ""
    var unitPrice: Double = 0.0
    var quantity: Double = 0.0
    var tableIndex:Int?
    var isCorrect:Bool = true
    @IBOutlet weak var descBox: UITextField!
    @IBOutlet weak var qtyBox: UITextField!
    @IBOutlet weak var upBox: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        descBox.text = item?.Description ?? ""
        qtyBox.text = "\(item?.SalesItemLineDetail.Qty ?? 1)"
        upBox.text = "\(item?.SalesItemLineDetail.UnitPrice ?? 0)"
        // Do any additional setup after loading the view.
    }

    func showAlert(message: String){
        let alert = UIAlertController(title: "Form Validation", message: message, preferredStyle: .alert )
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }


    @IBAction func donePressed(_ sender: Any) {
        desc = descBox.text ?? "N/A"
        if Validation.isDouble(qtyBox.text!) {
            quantity = Double(qtyBox.text!) ?? 0.0
        }
        else{
            isCorrect = false
            return
        }
        if Validation.isDouble(upBox.text!) {
            unitPrice = Double(upBox.text!) ?? 0.0
        }
        else{
            isCorrect = false
            return
        }
        saleItem = SaleItemLineDetail.init(q: quantity, up: unitPrice)
        item = Lines.init(item: saleItem!, d: desc, ln: 0)
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
