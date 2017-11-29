//
//  FirebaseMethods.swift
//  DareSpot
//
//  Created by Ubale Sushant on 11/6/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
struct Service {
    static let sharedInstance = Service()
    let USER_REF = Database.database().reference().child("userInformation")
    let USER_MESSAGE = Database.database().reference().child("messages")


    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

    }
    func resetPassword(email:String, completion: @escaping (_ error:Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error1) in
            if error1 != nil {
                print("error = \(String(describing: error1?.localizedDescription))")
                completion(error1!)
                return
            }
            else {
                completion(nil)
                
                
                print("Email link send to your email address")
                
            }
        }
    }
    
    
    
    func fetchEmails(email:String, completion: @escaping (_ erroor:Error?,_ array:[String]?) -> ()) {
        Auth.auth().fetchProviders(forEmail: email) { (arrayOfValidUsers, error1) in
           
            if error1 != nil {
                completion(error1, nil)
                
            }
            else {
                completion(error1 , arrayOfValidUsers)
                
                print("fetched Emails")

            }
            
        }
    }
    
    func createSingleUser (email:String, password:String,completion:@escaping (_ user:String?, _ error:Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user1, error1) in
            if error1 == nil {
                completion(user1?.uid,nil)
            }
            else {
                completion(nil, error1)
            }
        }

        
    }
    
    func singInUser(email:String?, password:String?, completion: @escaping (_ user:String?,_ error:Error?) -> ()) {
        Auth.auth().signIn(withEmail: email!, password: password!) { (user1, error1) in
            if error1 == nil {
                completion(user1?.email, nil)
            }
            else {
                completion(nil,error1)
            }
        }
    }
    
    
    
}




