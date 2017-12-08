//
//  SignUpGenderDOBViewController.swift
//  DareSpot
//
//  Created by Mrunalini on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit

class SignUpGenderDOBViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var genderRadioButton: DLRadioButton!
    var genderSelection = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        birthDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        birthDatePicker.datePickerMode = .date
        genderRadioButton.isMultipleSelectionEnabled = false
        birthDatePicker.isHidden = true
dateTextfield.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpGenderDOBViewController.dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)


    }
    func dismissKeyboard() {
        birthDatePicker.isHidden = true

        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func genderButtonClicked(_ sender: DLRadioButton) {
        
        if sender.tag == 1 {
            self.genderSelection = "Male"
            print(self.genderSelection)
        }
        else {
            self.genderSelection = "Female"
            print(self.genderSelection)

        }
    }
    func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateTextfield.text = dateFormatter.string(from: birthDatePicker.date)
        dateTextfield.resignFirstResponder()

    }
    
   
    @IBAction func nextButtonPressed(_ sender: Any) {
        if dateTextfield.text == "" {
            return
        }
        UserInformation.userInformationInstance.dOB  = dateTextfield.text
        UserInformation.userInformationInstance.gender = self.genderSelection
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        birthDatePicker.isHidden = false
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        birthDatePicker.isHidden = true
    }
  
}
