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
    var alert = UIAlertController()

    
    
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
        
        if let email = self.emailTextField.text {

            Service.sharedInstance.resetPassword(email: email, completion: { (error) in
                if error == nil {
                    print("An email has been sent you to change the password")
                     self.alert = UIAlertController(title: "Please check your email!",
                                                                              message: "A link to change the password has been sent tpo your email address.",
                                                                              preferredStyle: UIAlertControllerStyle.alert)
                    let login = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                        
                        self.performSegue(withIdentifier: "userExistSegue", sender: nil)
                        
                    }
                    self.alert.addAction(login)
                    self.present(self.alert, animated: true, completion: nil)
                    
                }
                else {
                    self.alert = UIAlertController(title: "Error",
                                                                          message: error?.localizedDescription,
                                                                          preferredStyle: UIAlertControllerStyle.alert)

                    let errorAlert = UIAlertAction(title: "Error", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                        
                        
                    }
                    self.alert.addAction(errorAlert)
                    self.present(self.alert, animated: true, completion: nil)

                    
                }
 
                })

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
        
        Service.sharedInstance.fetchEmails(email: email) { (error, array) in
            if error == nil && array != nil {
                print("There is an active account")
                 self.alert = UIAlertController(title: "Account Exist!!!!",
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
                
                self.alert.addAction(login)
                self.alert.addAction(changePassword)
                self.present(self.alert, animated: true, completion: nil)
            }
            else {
                print("No account, go to signUPnameViewController")
                self.goToSignUpNameViewController()
            }
            
        }
        
        
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


