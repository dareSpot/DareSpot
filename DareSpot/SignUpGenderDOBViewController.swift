//
//  SignUpGenderDOBViewController.swift
//  DareSpot
//
//  Created by Mrunalini on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit

class SignUpGenderDOBViewController: UIViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func nextButtonPressed(_ sender: Any) {
        UserInformation.userInformationInstance.dOB  = "05/13/1990"
        UserInformation.userInformationInstance.gender = "Female"
        
    }
  
}
