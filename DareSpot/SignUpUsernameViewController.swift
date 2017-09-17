//
//  SignUpUsernameViewController.swift
//  DareSpot
//
//  Created by Mrunalini on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import Firebase

class SignUpUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    var fireBaseRefrence: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if let mydata = snapshot.value as? NSDictionary {
                print("mydata = \(mydata)")
            }
        })
        
        if let username = self.usernameTextField.text {
            UserInformation.userInformationInstance.username = username
            UserInformation.userInformationInstance.phoneNumber = "9999999999"
        }
    }

}
