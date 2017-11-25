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
    var alert = UIAlertController()
    override func viewDidLoad() {
        print("SignInUserViewController")

        super.viewDidLoad()
    
        
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
        self.emailTextfield.text = ""
        self.passwordTextfield.text = ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goToShowProfileViewController() {
        
        performSegue(withIdentifier: "showProfile", sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text , let password = passwordTextfield.text {
            
            Service.sharedInstance.singInUser(email: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("no error")
                    self.isLoginSuccessful = true
                    self.goToShowProfileViewController()

                }
                else {
                    print("error")
                    
                    
                    self.alert = UIAlertController(title: "Error",
                                                  message: error?.localizedDescription,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    
                    let login = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                    }
                    let changePassword = UIAlertAction(title: "Change Password ?", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        self.goToChangePasswordViewController()
                    }
                    
                    self.alert.addAction(login)
                    self.alert.addAction(changePassword)
                    self.present(self.alert, animated: true, completion: nil)
                    
 
                }
            })

        }

    }
    
    func goToChangePasswordViewController () {
        if let email = self.emailTextfield.text {
            Service.sharedInstance.resetPassword(email: email, completion: { (error) in
                if error == nil {
                    print("An email has been sent you to change the password")
                    self.alert = UIAlertController(title: "Please check your email!",
                                                   message: "A link to change the password has been sent tpo your email address.",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                    let login = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                        
                        self.emailTextfield.text = ""
                        self.passwordTextfield.text = ""
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

    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showProfile" {
            let dvc = segue.destination as! SearchFriendViewController
            SearchFriendViewController.loggedInEmailAddress = self.emailTextfield.text!

        }


        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
