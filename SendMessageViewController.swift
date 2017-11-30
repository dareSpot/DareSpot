//
//  SendMessageViewController.swift
//  DareSpot
//
//  Created by Ubale Sushant on 11/18/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CoreLocation

class SendMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var messagesTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var loggedInFriendList = [Dictionary<String, Any>]()
    var userFriendsEmails = [String:Any]()
    var navBarTitle = ""
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var myNavigationBar: UINavigationBar!
    var challengesArray = [String]()

    let barHeight: CGFloat = 50
    var items = [Message]()
    let locationManager = CLLocationManager()
    var canSendLocation = true
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    override func viewDidLoad() {
        print("sendMessageViewController")
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        self.getData(SearchFriendViewController.loggedInEmailAddress)
        self.myNavigationBar.topItem?.title = navBarTitle
        
      //  self.observeMessagesFromFriend()
        
        self.customization()
        self.fetchData()



    }
    func customization() {
//        self.imagePicker.delegate = self
        self.myTableView.estimatedRowHeight = self.barHeight
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        self.myTableView.contentInset.bottom = self.barHeight
        self.myTableView.scrollIndicatorInsets.bottom = self.barHeight
        self.locationManager.delegate = self


    }
    
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        self.canSendLocation = true
        self.animateExtraButtons(toHide: true)
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func animateExtraButtons(toHide: Bool)  {
        switch toHide {
        case true:
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
//                self.inputBar.layoutIfNeeded()
            }
        default:
            self.bottomConstraint.constant = -50
            UIView.animate(withDuration: 0.3) {
//                self.inputBar.layoutIfNeeded()
            }
        }
    }
    
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.myTableView.contentInset.bottom = height
            self.myTableView.scrollIndicatorInsets.bottom = height
            if self.items.count > 0 {
                self.myTableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        if let lastLocation = locations.last {
            if self.canSendLocation {
                let coordinate = String(lastLocation.coordinate.latitude) + ":" + String(lastLocation.coordinate.longitude)
                let message = Message.init(type: .location, content: coordinate, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
                Message.send(message: message, toID: SearchFriendViewController.receiverId, completion: {(_) in
                })
                self.canSendLocation = false
            }
        }
    }
    func fetchData() {
        let currentUser = Auth.auth().currentUser?.uid
        Message.downloadAllMessages(forUserID: SearchFriendViewController.receiverId, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.myTableView.reloadData()
                    weakSelf?.myTableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
        })
        Message.markMessagesRead(forUserID: currentUser!)
    }
    
    
    
    
    func observeMessagesFromFriend () {
        
        
       
        Database.database().reference().child("messages").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                var personalMessages = Messages()
                personalMessages.key = snapshot.key
                personalMessages.setValuesForKeys(dictionary)
                print("message.key = \(personalMessages)")
                
                
            }
            
        }, withCancel: nil)
    }

    @IBAction func backButttonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
//        let referenceForMessages = Database.database().reference().child("messages")
//        let childMessages = referenceForMessages.childByAutoId()
//        let timeStamp = NSDate().timeIntervalSince1970
//        let values = ["text":self.messagesTextField.text!,"toID":SearchFriendViewController.receiverId,"fromID":SearchFriendViewController.loggedInid,"timeStamp":timeStamp] as [String : Any]
//        childMessages.updateChildValues(values)
//        
//        self.myTableView.reloadData()
        
        
        if let text = self.messagesTextField.text {
            if text.characters.count > 0 {
                self.composeMessage(type: .text, content: self.messagesTextField.text!)
                self.messagesTextField.text = ""
            }
        }
    }
    
    func composeMessage(type: MessageType, content: Any)  {
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message, toID: SearchFriendViewController.receiverId, completion: {(_) in
        })
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
                            if let toEmail = dataOfFriend["email"] as? String {

                                print("loggedinEmail = \(SearchFriendViewController.loggedInEmailAddress) \n receiverEmail = \(SearchFriendViewController.receiverEmailAddress) \n loggedInId = \(SearchFriendViewController.loggedInid) \n receiverId = \(SearchFriendViewController.receiverId)")
                                
                                
                            }
                            
                        }
                        
                    }
                }
                
                
            }
            
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.messagesTextField.resignFirstResponder()
        switch self.items[indexPath.row].type {
        case .photo:
            if let photo = self.items[indexPath.row].image {
                let info = ["viewType" : ShowExtraView.preview, "pic": photo] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
                self.inputAccessoryView?.isHidden = true
            }
        case .location: break
            let coordinates = (self.items[indexPath.row].content as! String).components(separatedBy: ":")
            let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(coordinates[0])!, longitude: CLLocationDegrees(coordinates[1])!)
            let info = ["viewType" : ShowExtraView.map, "location": location] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
            self.inputAccessoryView?.isHidden = true
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items[indexPath.row].owner {
        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            switch self.items[indexPath.row].type {
            case .text:
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
                } else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.myTableView.reloadData()
                            }
                        }
                    })
                }
            case .location:
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            }
            return cell
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.clearCellData()
//            cell.profilePic.image = self.currentUser?.profilePic
            switch self.items[indexPath.row].type {
            case .text:
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
                } else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.myTableView.reloadData()
                            }
                        }
                    })
                }
            case .location:
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.myTableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let currentUser = Auth.auth().currentUser?.uid
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        Message.markMessagesRead(forUserID: currentUser!)
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
