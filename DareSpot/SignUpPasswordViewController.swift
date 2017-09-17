//
//  SignUpPasswordViewController.swift
//  DareSpot
//
//  Created by Mrunalini on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpPasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
     var fireBaseRefrence: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fireBaseRefrence = Database.database().reference().child("userInformation")
        
        print("UserInformation.userInformationInstance.firstName = \(String(describing: UserInformation.userInformationInstance.firstName))")
        print("UserInformation.userInformationInstance.lastName = \(String(describing: UserInformation.userInformationInstance.lastName))")
        print("UserInformation.userInformationInstance.dob = \(String(describing: UserInformation.userInformationInstance.dOB))")
        
        print("UserInformation.userInformationInstance.gender = \(String(describing: UserInformation.userInformationInstance.gender))")
        
        print("UserInformation.userInformationInstance.email = \(String(describing: UserInformation.userInformationInstance.email))")
        
        print("UserInformation.userInformationInstance.phone = \(String(describing: UserInformation.userInformationInstance.phoneNumber))")

    }


    @IBAction func registerButtonPressed(_ sender: UIButton) {
        self.addUserInformation()
        
    }
    
    func addUserInformation() {
        if let password = self.passwordTextField.text, let comfirmPassword1 = self.confirmPasswordTextField.text {
            UserInformation.userInformationInstance.password = password
            UserInformation.userInformationInstance.comnfirmPassword = comfirmPassword1
        }
        
        let key = fireBaseRefrence.childByAutoId().key
        let userInfo = ["id": key,
                        "firstName": UserInformation.userInformationInstance.firstName,
                        "lastName": UserInformation.userInformationInstance.lastName,
                        "dateOfBirth": UserInformation.userInformationInstance.dOB,
                        "gender": UserInformation.userInformationInstance.gender,
                        "email": UserInformation.userInformationInstance.email,
                        "phoneNumber": UserInformation.userInformationInstance.phoneNumber,
                        "userName": UserInformation.userInformationInstance.username,
                        "password": UserInformation.userInformationInstance.password,
                        "confirmPassword": UserInformation.userInformationInstance.comnfirmPassword]
        
        fireBaseRefrence.child(key).setValue(userInfo)
    }
    
    

}
