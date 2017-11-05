//
//  SignInUserExistViewController.swift
//  DareSpot
//
//  Created by Ubale Sushant on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInUserExistViewController: UIViewController {
    var isLoginSuccessful = false
    var emailTextField : String!

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goToShowProfileViewController() {
        
        performSegue(withIdentifier: "showProfile", sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text , let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("no error")
                    self.isLoginSuccessful = true
                self.goToShowProfileViewController()
                }
                else {
                    print("error")
                    print(error?.localizedDescription ?? 1)
                    
                    
                    let alert = UIAlertController(title: "Account Exist!!!!",
                                                  message: error?.localizedDescription,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    
                    let login = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                    }
                    let changePassword = UIAlertAction(title: "Change Password ?", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        self.goToChangePasswordViewController()
                    }
                    
                    alert.addAction(login)
                    alert.addAction(changePassword)
                    self.present(alert, animated: true, completion: nil)

                    
                }
            })
 
        }

    }
    
    func goToChangePasswordViewController () {
        
        if let email = self.emailTextfield.text {
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
                        
                        
                    }
                    alertForSuccessfulChangedPassword.addAction(login)
                    self.present(alertForSuccessfulChangedPassword, animated: true, completion: nil)
                    
                }
                
            }
    }
    }

    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if self.isLoginSuccessful {
//            let passwordViewController:ChangePasswordViewController = ChangePasswordViewController()
//            
//            
//        }
//        else {
//            
//            if segue.identifier == "changePassword" {
//                if let destination =  segue.destination as? ChangePasswordViewController {
//                    if emailTextField != nil {
//                        destination.email = self.emailTextfield.text!
//                    }
//                }
//            }
//            
//        }
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
    

}
