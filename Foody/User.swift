//
//  User.swift
//  Foody
//
//  Created by Giovanni Lenguito on 21/11/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import Foundation
class User: NSObject {
    //MARK: Properties
    var username : String = ""
    var fullname : String = ""
    var email : String = ""
    var password : String = ""
    var profilePicture : String = ""
    
    //MARK: Types
    
    //Initialise User
    init(username: String, fullname: String, email: String, password: String){
        self.username = username
        self.fullname = fullname
        self.email = email
        self.password = password
    }
}
