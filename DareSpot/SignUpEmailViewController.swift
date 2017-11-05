//
//  SignUpEmailViewController.swift
//  DareSpot
//
//  Created by Mrunalini on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpEmailViewController: UIViewController
{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
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
    
    
    func goTochangePasswordViewController() {
        
//        performSegue(withIdentifier: "changePassword", sender: nil)
        if let email = self.emailTextField.text {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                print("Can't change the password")
            }
            else {
                
            print("An email has been sent you to change the password")
                
                
                
                
                let alertForSuccessfulChangedPassword = UIAlertController(title: "Please check your email!",
                                                                          message: "A link to change the password has been sent tpo your email address.",
                                                                          preferredStyle: UIAlertControllerStyle.alert)
                
                let login = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) {
                    (result : UIAlertAction) -> Void in
                    
                    self.performSegue(withIdentifier: "userExistSegue", sender: nil)

                }
                alertForSuccessfulChangedPassword.addAction(login)
                self.present(alertForSuccessfulChangedPassword, animated: true, completion: nil)

            }
            
        }
        }

    }
    
    func goToUserExistViewController() {
        
        performSegue(withIdentifier: "userExistSegue", sender: nil)
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
        else if segue.identifier == "userExistSegue" {
                if let destination =  segue.destination as? SignInUserExistViewController {
                    if emailTextField != nil {
                        destination.emailTextField = self.emailTextField.text
                        
                    }
                }
        }
        else if segue.identifier == "changePassword" {
            if let destination =  segue.destination as? ChangePasswordViewController {
                if emailTextField != nil {
                    destination.email = self.emailTextField.text!
                    
                }
            }
        }
    }
    
    
    func checkAccount(email: String) {
        
        Auth.auth().fetchProviders(forEmail: email, completion: { (stringArray, error) in
            if error != nil {
                print(error!)
            }
            else {
                if stringArray == nil {
                    print("No password. No active account")
                    self.goToSignUpNameViewController()

                }
                else {
                    // login and change password
                    
                    print("There is an active account")
                    
                    let alert = UIAlertController(title: "Account Exist!!!!",
                                                  message: "There is already a account existing with this email address. Do you want to Login or Change Password ?",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    
                    let login = UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                        self.goToUserExistViewController()
                        
                    }
                    
                    
                    let changePassword = UIAlertAction(title: "Change Password ?", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("Change PAssword yet to be implemented.")
                        self.goTochangePasswordViewController()
                        
                    }
                    
                    alert.addAction(login)
                    alert.addAction(changePassword)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
            }
        })
    }
   
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
         if let email = self.emailTextField.text {
            self.checkAccount(email: email)
        }
        else {
            
            return
        }
    }
}


