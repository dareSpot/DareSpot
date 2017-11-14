//
//  SearchFriendViewController.swift
//  DareSpot
//
//  Created by Ubale Sushant on 11/8/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class SearchFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var dareSpotFriend: UIButton!
    @IBOutlet weak var emailFriendTextField: UITextField!
    var loggedInEmailAddress: String = ""
    var friendListArray = [String:Any]()
    var userNames = [String]()
    var loggedInFriendList = [Dictionary<String, Any>]()

    var USER_FRIENDS = Database.database().reference().child("friendList")
    var  loggedInid = ""
    var userFriendsEmails = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.reloadData()

        myTableView.delegate = self
        myTableView.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
    var CURRENT_USER_ID: String {
        let id = Auth.auth().currentUser!.uid
        return id
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dareSpotButtonPressed(_ sender: UIButton) {
        
        let USER_REF = Database.database().reference().child("userInformation")
        
        // logged user info
        
        
        let loggedInUser = self.loggedInEmailAddress
        USER_REF.queryOrdered(byChild:  "email").queryStarting(atValue: loggedInUser).queryEnding(atValue: loggedInUser + "\u{f8ff}").observeSingleEvent(of: .value, with: { (loggedIn) in
            print("loggedIn = \(loggedIn)")
            let loggedInUserInformation = loggedIn.value as? NSDictionary
            if let myArray = loggedInUserInformation?.objectEnumerator().allObjects as? [[String:Any]] {
                for userAddingInfo in myArray {
                     self.loggedInid = (userAddingInfo["id"] as? String)!
                    if let friendList = (userAddingInfo["friendList"])  {
                        do {
                            self.loggedInFriendList = [friendList as! Dictionary<String, Any>]
                            print("self.loggedInFriendList = \(self.loggedInFriendList)")

                            
                        } catch {
                            print("Error \(error)")
                        }
                    }
                    
                    for allEmails in self.loggedInFriendList {
                        print("allEmails = \(allEmails)")
                        self.userFriendsEmails = allEmails
                        
                    }
                    
                    
                }
            }
        })
        
        
        // added user info
        
        let strSearch = self.emailFriendTextField.text
        USER_REF.queryOrdered(byChild:  "email").queryStarting(atValue: strSearch).queryEnding(atValue: strSearch! + "\u{f8ff}").observeSingleEvent(of: .value, with: { (addedUser) in
            print("addedUser = \(addedUser)")
            let addedUserInformation = addedUser.value as? NSDictionary
            if addedUser.childrenCount == 0 {
                let alert = UIAlertController(title: "Error",
                                               message: "The email doesn't exist",
                                               preferredStyle: UIAlertControllerStyle.alert)
                
                let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) {
                    (result : UIAlertAction) -> Void in
                    return
                }
                
                alert.addAction(Ok)
                self.present(alert, animated: true, completion: nil)
                

            }
            if let myArray = addedUserInformation?.objectEnumerator().allObjects as? [[String:Any]] {
                for userAddingInfo in myArray {
                    let dateOfBirth = userAddingInfo["dateOfBirth"] as? String
                    let email = userAddingInfo["email"] as? String
                    let firstName = userAddingInfo["firstName"] as? String
                    let id = userAddingInfo["id"] as? String
                    let lastName = userAddingInfo["lastName"] as? String
                    let phoneNumber = userAddingInfo["phoneNumber"] as? String
                    let userName = userAddingInfo["userName"] as? String
                    print("dateOfBirth = \(String(describing: dateOfBirth)) \n email = \(String(describing: email)) \n firstName = \(String(describing: firstName)) \n id = \(id!) \n lastName = \(String(describing: lastName)) \n phoneNumber = \(String(describing: phoneNumber)) \n userName = \(String(describing: userName))")
                    
                    self.friendListArray = ["firstName":firstName!,"lastName":lastName!,"email":email!,"userName":userName!,"phoneNumber":phoneNumber!,"dateOfBirth":dateOfBirth!,"id":id!]
                    self.userNames.append(email!)
                    self.myTableView.reloadData()
                    
                   let  fireBaseRefrence = Database.database().reference().child("userInformation").child(self.loggedInid).child("friendList")
                    fireBaseRefrence.child(id!).setValue(self.friendListArray)
                }
            }
            
        })
        
        
        
        
    }
    
    
    // MARK: - UITableViewDelegate
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("userInformation").child(CURRENT_USER_ID).child("friendList")
.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
    if let userDict = snapshot.value as? [String:Any] {
        //Do not cast print it directly may be score is Int not string
        print("userDict = \(userDict["email"])")
        
        
        
        
        
        
        
    }

    
//     let value1 = snapshot.value as? NSDictionary
//      for (key, value) in value1! {
//        print("\(key) -> \(value)")
//        print(value)
//    }
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    })
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.myTableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = self.userNames[indexPath.row]
        
        
        return cell

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userNames.count
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
