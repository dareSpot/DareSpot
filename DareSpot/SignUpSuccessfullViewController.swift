//
//  SignUpSuccessfullViewController.swift
//  DareSpot
//
//  Created by Ubale Sushant on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import UIKit
import DialogBox
class SignUpSuccessfullViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appearance = BoxAppearance()
        
        // Layout
        appearance.layout.backgroundColor = UIColor.init(red: 99.0/255.0, green: 157.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        appearance.layout.cornerRadius = 10.0
        appearance.layout.width = 300.0
        
        // Title
        appearance.title.textColor = UIColor.white
        appearance.title.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        // Message
        appearance.message.textColor = UIColor.white
        appearance.message.font = UIFont.systemFont(ofSize: 17.0)
        
        // Icon
        appearance.icon.type = BoxIconType.image
        appearance.icon.image.name = "email"
        appearance.icon.margin = "0|30|0|20"
        appearance.icon.position = BoxIconPosition.topCenter
        appearance.icon.size = CGSize(width: 116, height: 117)
        
        // Animation
        appearance.animation = BoxAnimationType.bounce
        
        // Button
        appearance.button.bottomPosition.cornerRadius = 20
        appearance.button.backgroundColor = UIColor.init(red: 99.0/255.0, green: 157.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        appearance.button.textColor = UIColor.white
        appearance.button.borderColor = UIColor.white
        appearance.button.borderWidth = 2.0
        appearance.button.containerMargin = "70|20|70|40"
        
        DialogBox.show(title: "Congratulations!!!!", message: "Your email has been successfully registered with DareSpot. You can login with your credentials now.", superView: self.view, boxApp: appearance, buttonTitle: "Okay", buttonAppearance: nil) {
            print("done")
            
            self.performSegue(withIdentifier: "signUpComplete", sender: nil)

            
            
            
        }
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
