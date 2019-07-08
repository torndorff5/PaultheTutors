//
//  CustomerDetailViewController.swift
//  EstimationAutomation
//
//  Created by codeslinger on 5/24/19.
//  Copyright © 2019 SpokaneAutomationCompany. All rights reserved.
//

import UIKit

class CustomerDetailViewController: UIViewController, UITextViewDelegate {
    
    var customer:Customer?
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var middlename: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var primaryphone: UITextField!
    @IBOutlet weak var altphone: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var saveChanges: UIButton!
    @IBOutlet weak var createEstimate: UIButton!
    var firstTime:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cusaddr = customer?.ShipAddr    
        altphone.text = customer?.AlternatePhone.FreeFormNumber
        firstname.text = customer?.GivenName
        middlename.text = customer?.MiddleName
        lastname.text = customer?.FamilyName
        email.text = customer?.PrimaryEmailAddr.Address
        primaryphone.text = customer?.PrimaryPhone.FreeFormNumber
        street.text = cusaddr?.Line1
        city.text = cusaddr?.City
        state.text = cusaddr?.CountrySubDivisionCode
        zip.text = cusaddr?.PostalCode
        if customer?.Notes == ""{
            notes.text = "Add customer notes here."
        }
        else {
            notes.text = customer?.Notes
        }
        firstname.sizeToFit()
        middlename.sizeToFit()
        lastname.sizeToFit()
        email.sizeToFit()
        primaryphone.sizeToFit()
        altphone.sizeToFit()
        street.sizeToFit()
        city.sizeToFit()
        state.sizeToFit()
        zip.sizeToFit()
        //make sure they cant be edited
        createEstimate.isHidden = true
        toggleInteraction()
        notes.delegate = self
        firstTime = true
    }
    func toggleInteraction(){
        firstname.isUserInteractionEnabled = !firstname.isUserInteractionEnabled
        middlename.isUserInteractionEnabled = !middlename.isUserInteractionEnabled
        lastname.isUserInteractionEnabled = !lastname.isUserInteractionEnabled
        email.isUserInteractionEnabled = !email.isUserInteractionEnabled
        primaryphone.isUserInteractionEnabled = !primaryphone.isUserInteractionEnabled
        altphone.isUserInteractionEnabled = !altphone.isUserInteractionEnabled
        street.isUserInteractionEnabled = !street.isUserInteractionEnabled
        city.isUserInteractionEnabled = !city.isUserInteractionEnabled
        state.isUserInteractionEnabled = !state.isUserInteractionEnabled
        zip.isUserInteractionEnabled = !zip.isUserInteractionEnabled
        notes.isUserInteractionEnabled = !notes.isUserInteractionEnabled
        notes.isEditable = !notes.isEditable
        saveChanges.isHidden = !saveChanges.isHidden
        createEstimate.isHidden = !createEstimate.isHidden
        
    }
    @IBAction func unwindToCustomerDetail(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func editCustomer(_ sender: Any) {
        toggleInteraction()
    }
    func showAlert(msg: String) {
        let alert = UIAlertController.init(title: "Customer Info Error", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    func detailValidation() -> Bool {
        if !Validation.isFirstNameValid(firstname.text ?? ""){
            showAlert(msg: "Invalid First Name")
            return false
        }
        else if !Validation.isLastNameValid(lastname.text ?? ""){
            showAlert(msg: "Invalid Last Name")
            return false
        }
        else if !Validation.isEmailValid(email.text ?? "") {
            showAlert(msg: "Invalid Email")
            return false
        }
        else if !Validation.isZipValid(zip.text ?? "") {
            showAlert(msg: "Invalid Zip")
            return false
        }
        else if !Validation.isPhoneValid(primaryphone.text ?? ""){
            showAlert(msg: "Invalid Primary Phone Number")
            return false
        }
        else if !Validation.isStateValid(state.text ?? ""){
            showAlert(msg: "Invalid State Code (e.g. WA)")
            return false
        }
        return true
    }
    @IBAction func updateCustomer(_ sender: Any) {
        //validate input
        if detailValidation() {//if valid,
            //post update to quickbooks
            customer?.GivenName = firstname.text!
            customer?.MiddleName = middlename.text!
            customer?.FamilyName = lastname.text!
            customer?.PrimaryEmailAddr.Address = email.text!
            customer?.PrimaryPhone.FreeFormNumber = primaryphone.text!
            customer?.AlternatePhone.FreeFormNumber = altphone.text!
            customer?.ShipAddr.Line1 = street.text!
            customer?.ShipAddr.City = city.text!
            customer?.ShipAddr.CountrySubDivisionCode = state.text!
            customer?.ShipAddr.PostalCode = zip.text!
            customer?.Notes = notes.text!
            customer?.DisplayName = "\(customer!.GivenName) \(customer!.MiddleName) \(customer!.FamilyName)"
            Backend.updateCustomer(c: customer!)
            toggleInteraction()
            var temp = Int(customer!.SyncToken) ?? 0
            temp += 1
            customer?.SyncToken = String(temp)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? CreateEstimateViewController {
            viewController.cus = customer
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstTime == true {
            textView.text = ""
            firstTime = !firstTime!
        }
    }
    
    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
