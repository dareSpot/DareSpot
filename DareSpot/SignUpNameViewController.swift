//
//  SignUpNameViewController.swift
//  DareSpot
//
//  Created by Mrunalini on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit

class SignUpNameViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var emailTextField : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if let firstName = self.firstNameTextField.text, let lastName = self.lastNameTextField.text  {
            UserInformation.userInformationInstance.firstName = firstName
            UserInformation.userInformationInstance.lastName = lastName
        }
            UserInformation.userInformationInstance.email = emailTextField
        
    }

}
