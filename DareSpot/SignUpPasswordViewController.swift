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
        
        if let password = self.passwordTextField.text, let comfirmPassword1 = self.confirmPasswordTextField.text {
            UserInformation.userInformationInstance.password = password
            UserInformation.userInformationInstance.comnfirmPassword = comfirmPassword1
        }
        self.createAccountAction()
    }
    
    func createAccountAction() {
        
        if UserInformation.userInformationInstance.email == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: UserInformation.userInformationInstance.email!, password: UserInformation.userInformationInstance.password!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    self.addUserInformation(uid: (user?.uid)!)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "signUpDone")
                    self.present(vc!, animated: true, completion: nil)
                    
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
            }
        }
    }
    
    func addUserInformation(uid: String) {

        let userInfo = ["id": uid,
                        "firstName": UserInformation.userInformationInstance.firstName,
                        "lastName": UserInformation.userInformationInstance.lastName,
                        "dateOfBirth": UserInformation.userInformationInstance.dOB,
                        "gender": UserInformation.userInformationInstance.gender,
                        "email": UserInformation.userInformationInstance.email,
                        "phoneNumber": UserInformation.userInformationInstance.phoneNumber,
                        "userName": UserInformation.userInformationInstance.username,
                        "password": UserInformation.userInformationInstance.password,
                        "confirmPassword": UserInformation.userInformationInstance.comnfirmPassword]
        
        fireBaseRefrence.child(uid).setValue(userInfo)
    }
}
