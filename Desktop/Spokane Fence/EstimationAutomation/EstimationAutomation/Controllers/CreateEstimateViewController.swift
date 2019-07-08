//
//  CreateEstimateViewController.swift
//  EstimationAutomation
//
//  Created by codeslinger on 5/29/19.
//  Copyright © 2019 SpokaneAutomationCompany. All rights reserved.
//

import UIKit
import SafariServices

class CreateEstimateViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate, SFSafariViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var firstTime:Bool?
    var cus:Customer?
    var length:Double?
    var bti:Bool?
    var eti:Bool? 
    var loc:String?
    var desc:String?
    var fencedata:String?
    var styleIndex:Int = 0
    var currentLine:Lines?
    var currentFenceLine:FenceLine?
    var currentGate:Gate?
    var currIndex:Int = -1
    var drawImage:UIImage?
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var margin: UITextField!
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var taxRate: UILabel!
    @IBOutlet weak var laborandmat: UILabel!
    
    
    var data = [Lines]()
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.notes.delegate = self
        self.margin.delegate = self
        firstTime = true
        self.picker.delegate = self
        self.picker.dataSource = self
        errorLabel.isHidden = true
        pickerData = ["Vinyl - White - Privacy - 6ft tall - GREEN posts", "Vinyl - White - Privacy - 6ft tall - ECONO posts", "Vinyl - White - Privacy - 6ft tall - PREM posts", "Vinyl - Tan - Privacy - 6ft tall - GREEN posts","Vinyl - Tan - Privacy - 6ft tall - ECONO posts","Vinyl - Tan - Privacy - 6ft tall - PREM posts"]
        picker.selectRow(0, inComponent: 0, animated: true)
        fencedata = pickerData[0]
        taxRate.text = String("\(taxationRate*100)%")
        totalAmount.text = "0.0"
        subTotal.text = "0.0"
        margin.text = "1.0"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func recalcTotals() {
        let landm = calcTotal()
        let sub = landm * getMarg()
        let marg = sub - landm
        let total = sub * (1+taxationRate)
        laborandmat.text = String(format:"$%.02f",landm)
        profit.text = String(format:"$%.02f",marg)
        subTotal.text = String(format:"$%.02f",sub)
        totalAmount.text = String(format:"$%.02f",total)
        subTotal.sizeToFit()
        laborandmat.sizeToFit()
        profit.sizeToFit()
        totalAmount.sizeToFit()
    }
    func addLineItem (item:Lines) {
        if(currIndex != -1){
            data[currIndex] = item
        }
        else{
            data.append(item)
        }
        tableView.reloadData()
        recalcTotals()
    }
    
    @IBAction func unwindToCreateEstimate(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
        if let lineVC = unwindSegue.source as? CreateLineViewController {
            if Validation.isDouble(lineVC.length.text ?? ""){
                errorLabel.isHidden = true
                length = Double(lineVC.length.text!)
                bti = lineVC.bti.isOn
                eti = lineVC.eti.isOn
                loc = lineVC.loc
                desc = genLineDesc(loc:loc ?? "Left Return")
                let newFenceLine = lineStyleSelector(index: styleIndex)
                currIndex = lineVC.tableIndex ?? -1
                let newLine = Lines.init(item: newFenceLine, d: desc!, ln: currIndex)
                addLineItem(item: newLine)
            }
            else{
                errorLabel.isHidden = false
            }
        }//Need to validate all the forms
        if let lineVC = unwindSegue.source as? CreateGateViewController {
            if Validation.isDouble(lineVC.length.text ?? ""){
                errorLabel.isHidden = true
                length = Double(lineVC.length.text!)
                loc = lineVC.loc
                desc = genGateDesc(loc:loc ?? "Left Return")
                currIndex = lineVC.tableIndex ?? -1
                let newGate = gateStyleSelector(index: Int(length!))
                let newLine = Lines.init(item: newGate, d: desc!, ln: currIndex)
                addLineItem(item: newLine)
            }
            else{
                errorLabel.isHidden = false
            }
        }
        if let customerVC = unwindSegue.source as? CreateCustomServiceViewController {
            //add line item
            if customerVC.isCorrect {
                errorLabel.isHidden = true
                currIndex = customerVC.tableIndex ?? -1
                addLineItem(item: customerVC.item!)
            }
            else {
                errorLabel.isHidden = false
            }
        }
        if let drawVC = unwindSegue.source as? DrawingViewController {
            drawImage = drawVC.tempImageView.image
        }
    }
    func genLineDesc(loc:String) -> String {
        return "\(loc): \(fencedata!)"
    }
    func genGateDesc(loc:String) -> String {
        return "\(loc): \(fencedata!) - \(length!) ft wide Gate with hardware"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fenceitemcell", for: indexPath) as! FenceItemCellTableViewCell
        let item = data[indexPath.row]
        cell.desc.text = item.Description
        cell.amount.text = String(format: "$%.02f", item.Amount)
        cell.qtyft.text = String(item.SalesItemLineDetail.Qty)
        cell.desc.sizeToFit()
        cell.amount.sizeToFit()
        cell.qtyft.sizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currIndex = indexPath.row
        if let c = data[indexPath.row].SalesItemLineDetail as? FenceLine {
            currentFenceLine = c
            performSegue(withIdentifier: "showLineDetail", sender: nil)
            return
        }
        if let c = data[indexPath.row].SalesItemLineDetail as? Gate {
            currentGate = c
            performSegue(withIdentifier: "showGateDetail", sender: nil)
            return
        }
        let c = data[indexPath.row]
        currentLine = c
        performSegue(withIdentifier: "showCustomLineDetail", sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            recalcTotals()
        }
        if editingStyle == .insert {
            performSegue(withIdentifier: "addItemDetail", sender: nil)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? CreateLineViewController {
            viewController.len = currentFenceLine?.length
            viewController.e = currentFenceLine?.eti
            viewController.b = currentFenceLine?.bti
            viewController.loc = currentFenceLine?.Location
            viewController.tableIndex = currIndex
        }
        if let viewController = segue.destination as? CreateGateViewController {
            viewController.len = currentGate?.length
            viewController.loc = currentGate?.Location
            viewController.tableIndex = currIndex
        }
        if let viewController = segue.destination as? CreateCustomServiceViewController {
            viewController.item = currentLine
            viewController.tableIndex = currIndex
        }
        if let viewController = segue.destination as? DrawingViewController {
            viewController.image = drawImage
        }
        
    }

    func showAlert(message: String){
        let alert = UIAlertController(title: "Form Validation", message: message, preferredStyle: .alert )
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func getMarg() -> Double {
        if !Validation.isDouble(margin.text!) {
            showAlert(message: "Invalid Margin Multiplier")
            margin.text = "1.0"
            return 1.0
        }
        let val = Double(margin.text!) ?? 1.0
        if val < 1.0 {
            showAlert(message: "Invalid Margin Multiplier")
            margin.text = "1.0"
            return 1.0
        }
        return val
    }
    func calcTotal() -> Double {
        //get Amount of each line and sum it
        var sum = 0.0
        for d in data {
            d.calcAmount()
            sum += d.Amount
        }
        return sum
    }

    func addMargToLine(lines:[Lines]) -> [Lines]{
        for d in lines {
            d.SalesItemLineDetail.UnitPrice *= getMarg()
            d.calcAmount()
        }
        return lines
    }
    
    @IBAction func saveEstimate(_ sender: Any){
        //create estimate object
        var est = Estimate()
        est.CustomerRef = cus?.Id
        est.TotalAmt = calcTotal()
        est.PrivateNote = notes.text
        est.Line = addMargToLine(lines: data)
        est.ShipAddr = cus!.ShipAddr
        est.BillAddr = cus!.ShipAddr
        est.BillEmail = cus!.PrimaryEmailAddr
        //call save estimate function
        if Backend.validateToken() {
            est = Backend.createEstimate(est: est)//need to make sure the create estimate function works
            //figure out what to do with my drawing.
        }
        else{
            connectToQBO()
        }
    }
    
    @IBAction func saveAndSendEstimate(_ sender: Any) {
        var est = Estimate()
        est.CustomerRef = cus?.Id
        est.TotalAmt = calcTotal()
        est.PrivateNote = notes.text
        est.Line = addMargToLine(lines: data)
        est.ShipAddr = cus!.ShipAddr
        est.BillAddr = cus!.ShipAddr
        est.BillEmail = cus!.PrimaryEmailAddr
        //call save estimate function
        if Backend.validateToken() {
            est = Backend.createEstimate(est: est)//need to make sure the create estimate function works
            Backend.sendEstimate(est: est)
            //figure out what to do with my drawing.*************************
        }
        else {
            connectToQBO()
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstTime == true {
            textView.text = ""
            firstTime = !firstTime!
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        recalcTotals()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //left line , right line, left return, right return, back line
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fencedata = pickerData[row]
        styleIndex = row
    }

    func gateStyleSelector(index: Int) -> Gate{//needs to switch between 4 and 5 feet
        switch(index) {
        case 4:
            return GATE_WHITE_4_6(loc: loc ?? "Left Return", len: length!, q: 1)
        case 5:
            return GATE_WHITE_5_6(loc: loc ?? "Left Return", len: length!, q: 1)
        default:
            return GATE_WHITE_4_6(loc: loc ?? "Left Return", len: length!, q: 1)
        }
    }

    func lineStyleSelector(index: Int) -> FenceLine{
        switch(index) {
            case 0:
                return WHITE_GREENPOST_6_FenceLine(l: length!, bti: bti!, eti: eti!, loc: loc ?? "Left Return")
            case 1:
                return WHITE_ECONOPOST_6_FenceLine(l: length!, bti: bti!, eti: eti!, loc: loc ?? "Left Return")
            case 2:
                return WHITE_PREMPOST_6_FenceLine(l: length!, bti: bti!, eti: eti!, loc: loc ?? "Left Return")
            case 3:
                return TAN_GREENPOST_6_Fenceline(l: length!, bti: bti!, eti: eti!, loc: loc ?? "Left Return")
            case 4:
                return TAN_ECONOPOST_6_Fenceline(l: length!, bti: bti!, eti: eti!, loc: loc ?? "Left Return")
            case 5:
                return TAN_PREMPOST_6_Fenceline(l: length!, bti: bti!, eti: eti!, loc: loc ?? "Left Return")
            default:
                return WHITE_GREENPOST_6_FenceLine(l: length!, bti: bti!, eti: eti!, loc: loc ?? "Left Return")
        }
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        if !Backend.getAccessToken() {
            showAlert(message: "Error Authenticating")
        }
    }
    func connectToQBO(){
        let safariVC = Backend.safariVCinit()
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
}
