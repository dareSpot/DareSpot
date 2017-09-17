//
//  SignUpEmailViewController.swift
//  DareSpot
//
//  Created by Mrunalini on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import Firebase

class SignUpEmailViewController: UIViewController
{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
    }
    
    func isValidEmail(emailString:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    
    @IBAction func emailTextFieldEditing(_ sender: Any){
        if let email = self.emailTextField.text {
            if isValidEmail(emailString: email) {
                nextButton.isEnabled = true
                nextButton.alpha = 1
            } else {
                nextButton.isEnabled = false
                nextButton.alpha = 0.5
            }
        }
    }
    
    func goToSignUpNameViewController() {
        performSegue(withIdentifier: "signUPSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUPSegue" {
            if let destination =  segue.destination as? SignUpNameViewController {
                if emailTextField != nil {
                    destination.emailTextField = self.emailTextField.text
                }
            }
        }
    }
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
           goToSignUpNameViewController()
    }
}


