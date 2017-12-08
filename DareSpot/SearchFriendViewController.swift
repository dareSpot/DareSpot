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
import AudioToolbox

class SearchFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var dareSpotFriend: UIButton!
    @IBOutlet weak var emailFriendTextField: UITextField!
   static var loggedInEmailAddress: String = ""
    static var loggedInID:String = ""
    static var receiverEmailAddress:String = ""
    var friendListArray = [String:Any]()
    var userNames = [String]()
    var userEmails = [String]()
    var userProfilePics = [String]()

    var userIds = [String]()

    var loggedInFriendList = [Dictionary<String, Any>]()

    @IBOutlet weak var myNavBar: UINavigationBar!
    var userNameForNavTitle = ""
    var USER_FRIENDS = Database.database().reference().child("friendList")
   static var  loggedInid = ""
    var personalMessages = Messages()
var personalMessageArray = [String]()
    var userFriendsEmails = [String:Any]()
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "default profile")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(SearchFriendViewController.showProfile))
        return button
    }()
    var items = [Conversation]()

    
    override func viewDidLoad() {
        print("SearchViewController called")
        super.viewDidLoad()
        self.myTableView.reloadData()
        myTableView.delegate = self
        myTableView.dataSource = self
        self.getData(SearchFriendViewController.loggedInEmailAddress)
        self.myNavBar.topItem?.title = SearchFriendViewController.loggedInEmailAddress
        
//        self.customization()
//        self.fetchData()

    }
    
    @objc func showProfile() {
        let info = ["viewType" : ShowExtraView.profile]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
        self.inputView?.isHidden = true
    }

    
    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.myTableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        self.playSound()
                        break
                    }
                }
            }
        }
    }
    
    func customization()  {
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                let image = user.profilePic
                let contentSize = CGSize.init(width: 30, height: 30)
                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
                let _  = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
                path.lineWidth = 2
                UIColor.white.setStroke()
                path.stroke()
                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    weakSelf?.leftButton.image = finalImage
                    weakSelf = nil
                }
            })
        }
    }
    
    @objc func showContacts() {
        let info = ["viewType" : ShowExtraView.contacts]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
    }
    
    //Show EmailVerification on the bottom
//    @objc func showEmailAlert() {
//        User.checkUserVerification {[weak weakSelf = self] (status) in
//            status == true ? (weakSelf?.alertBottomConstraint.constant = -40) : (weakSelf?.alertBottomConstraint.constant = 0)
//            UIView.animate(withDuration: 0.3) {
//                weakSelf?.view.layoutIfNeeded()
//                weakSelf = nil
//            }
//        }
//    }
//    
    func playSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "newMessage", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlayAlertSound(soundID)
    }

    
   
    var CURRENT_USER_ID: String {
        let id = Auth.auth().currentUser!.uid
        return id
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        Service.sharedInstance.signOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(_ email:String) {

        let loggedInUser = email
        Service.sharedInstance.USER_REF.queryOrdered(byChild:  "email").queryStarting(atValue: loggedInUser).queryEnding(atValue: loggedInUser + "\u{f8ff}").observeSingleEvent(of: .value, with: { (loggedIn) in
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
                            if let oneEmail = dataOfFriend["userName"] as? String, let oneUsername = dataOfFriend["email"] as? String, let oneId = dataOfFriend["id"] as? String, let oneUserProfilePic = dataOfFriend["profilePic"] as? String {
                                SearchFriendViewController.receiverEmailAddress = dataOfFriend["email"] as! String
                                self.userNames.append(oneEmail)
                                self.userEmails.append(oneUsername)
                                self.userIds.append(oneId)
                                self.userProfilePics.append(oneUserProfilePic)
                                self.myTableView.reloadData()

                                
                            }
                            
                        }
                        
                    }
                }
                
                
            }

    })
    }
    @IBAction func dareSpotButtonPressed(_ sender: UIButton) {
        
        
        // logged user info
        
        var found = false
        let loggedInUser = SearchFriendViewController.loggedInEmailAddress
        Service.sharedInstance.USER_REF.queryOrdered(byChild:  "email").queryStarting(atValue: loggedInUser).queryEnding(atValue: loggedInUser + "\u{f8ff}").observeSingleEvent(of: .value, with: { (loggedIn) in
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
                                  if  self.emailFriendTextField.text == oneEmail {
                                      found = true
                                    
                                    let alert = UIAlertController(title: "Error",
                                                                  message: "The email already exists",
                                                                  preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) {
                                        (result : UIAlertAction) -> Void in
                                        self.emailFriendTextField.text = ""
                                        return
                                    }
                                    
                                    alert.addAction(Ok)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    
                                    }
                                    
                                }
                            
                        }
                        
                    }
                }
                
                if !found {
                    self.addToTable()
                }
            }
        })
    }
    
    func addToTable() {
        
        
        // added user info
        
        let strSearch = self.emailFriendTextField.text
        Service.sharedInstance.USER_REF.queryOrdered(byChild:  "email").queryStarting(atValue: strSearch).queryEnding(atValue: strSearch! + "\u{f8ff}").observeSingleEvent(of: .value, with: { (addedUser) in
            print("addedUser = \(addedUser)")
            let addedUserInformation = addedUser.value as? NSDictionary
            if addedUser.childrenCount == 0 {
                let alert = UIAlertController(title: "Error",
                                              message: "The email doesn't exist",
                                              preferredStyle: UIAlertControllerStyle.alert)
                
                let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) {
                    (result : UIAlertAction) -> Void in
                    self.emailFriendTextField.text = ""
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
                    let profilePic = userAddingInfo["profilePic"] as? String
                    print("dateOfBirth = \(String(describing: dateOfBirth)) \n email = \(String(describing: email)) \n firstName = \(String(describing: firstName)) \n id = \(id!) \n lastName = \(String(describing: lastName)) \n phoneNumber = \(String(describing: phoneNumber)) \n userName = \(String(describing: userName))")
                    
                    self.friendListArray = ["firstName":firstName!,"lastName":lastName!,"email":email!,"userName":userName!,"phoneNumber":phoneNumber!,"dateOfBirth":dateOfBirth!,"id":id!,"profilePic":profilePic!]
                    self.userNames.append(email!)
                    self.userEmails.append(userName!)
                    self.userProfilePics.append(profilePic!)

                    self.myTableView.reloadData()
                    
                    let  fireBaseRefrence = Database.database().reference().child("userInformation").child(SearchFriendViewController.loggedInid).child("friendList")
                    fireBaseRefrence.child(id!).setValue(self.friendListArray)
                }
            }
            
        })
    }
    
    
    func sendMessage(email:String) {
        
        let loggedInUser = SearchFriendViewController.loggedInEmailAddress
        Service.sharedInstance.USER_REF.queryOrdered(byChild:  "email").queryStarting(atValue: loggedInUser).queryEnding(atValue: loggedInUser + "\u{f8ff}").observeSingleEvent(of: .value, with: { (loggedIn) in
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
                                if  email == oneEmail {
                                    let toId = dataOfFriend["id"] as? String
                                    print("toId = \(String(describing: toId)) SearchFriendViewController.loggedInid = \(String(describing: SearchFriendViewController.loggedInid))")
                                }
                                
                            }
                            
                        }
                        
                    }
                }
                
                
            }
        })
    
        
    }
    
    // MARK: - UITableViewDelegate
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell

        self.sendMessage(email: (currentCell.detailTextLabel?.text)!)
         self.userNameForNavTitle =   (currentCell.textLabel?.text)!
        print(currentCell.textLabel!.text!)
        performSegue(withIdentifier: "sendMessageVC", sender: self.userIds[indexPath.row])
        

        
        
}
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.myTableView.dequeueReusableCell(withIdentifier: "cell")!
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        

        cell.textLabel?.text = self.userNames[indexPath.row]
        
        cell.detailTextLabel?.text = self.userEmails[indexPath.row]
        
        cell.imageView?.imageFromServerURL(urlString: self.userProfilePics[indexPath.row], PlaceHolderImage: UIImage(named: "dareSpotLogo")!)

        return cell

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userNames.count
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendMessageVC" {
            let nextScene = segue.destination as? SendMessageViewController
            
            let selectedVehicle = self.userNameForNavTitle
            nextScene?.navBarTitle = selectedVehicle
            nextScene?.singleUserId = sender as! String
            
//            nextScene.id = sender

        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

extension UIImageView {

    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

        if self.image == nil{
            self.image = PlaceHolderImage
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }}

