//
//  UserInformation.swift
//  DareSpot
//
//  Created by Mrunalini on 9/17/17.
//  Copyright © 2017 Mrunalini. All rights reserved.
//

import Foundation

class UserInformation: NSObject {
    
    static let userInformationInstance = UserInformation()
    var firstName: String?
    var lastName: String?
    var dOB: String?
    var gender: String?
    var email: String?
    var phoneNumber: String?
    var username: String?
    var password: String?
    var comnfirmPassword: String?
    
}
