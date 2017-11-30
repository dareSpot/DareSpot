//
//  ChallengeViewController.swift
//  DareSpot
//
//  Created by Ubale Sushant on 11/15/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import FirebaseDatabase
class ChallengeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var challengesArray = ["Drink One Galon Milk","Ice Bucket","Eat Pickel","Eat And Wear It","Eat Cinnamon","Eat Oreo","Blind Kissing Challenge","Blindfold Makeup Challenge","Blindfolded Drawing Challenge","Brain Freeze Challenge","Clingfilm Challenge"]
    
    @IBOutlet weak var challengeTableView: UITableView!
    var loggedInFriendList = [Dictionary<String, Any>]()
    var userFriendsEmails = [String:Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChallengeViewController called")
        challengeTableView.dataSource = self
        challengeTableView.delegate = self
        
        print(SearchFriendViewController.loggedInEmailAddress)
        
        print(SearchFriendViewController.loggedInid)
        

        self.getData(SearchFriendViewController.loggedInEmailAddress)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getData(_ email:String) {
        let USER_REF = Database.database().reference().child("userInformation")
        
        let loggedInUser = email
        USER_REF.queryOrdered(byChild:  "email").queryStarting(atValue: loggedInUser).queryEnding(atValue: loggedInUser + "\u{f8ff}").observeSingleEvent(of: .value, with: { (loggedIn) in
            print("loggedIn = \(loggedIn)")
            let loggedInUserInformation = loggedIn.value as? NSDictionary
            if let myArray = loggedInUserInformation?.objectEnumerator().allObjects as? [[String:Any]] {
                for userAddingInfo in myArray {
                    SearchFriendViewController.loggedInid = (userAddingInfo["id"] as? String)!
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
                        
                        for  friendEmail in allEmails {
                            let dataOfFriend: [String: AnyObject] = friendEmail.value as! [String : AnyObject]
                            if let oneEmail = dataOfFriend["email"] as? String {
                            print("oneEmail = \(oneEmail)")

                                
                            }
                            
                        }
                        
                    }
                }
                
                
            }
            
        })
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        
        print(currentCell.textLabel!.text!)
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = self.challengesArray[indexPath.row]
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challengesArray.count
        
        
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

extension Array
{
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
