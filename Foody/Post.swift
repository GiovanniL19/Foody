//
//  Post.swift
//  Foody
//
//  Created by Giovanni Lenguito on 02/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import Foundation
import UIKit

class Post: NSObject {
    //MARK: Properties
    var profilePicture : String = ""
    var username : String = ""
    var title : String = ""
    var image : String = ""
    var servings : Int = 0
    var desc : String = ""
    var method : String = ""
    var ingredients = [String]()
    var dateMade : Int = 0
    var time : Int = 0
    var difficulty : Int = 0
    
    // MARK: Initialization
    init(username: String, title: String, image: String, profilePicture: String, servings : Int, desc : String, method : String, ingredients : [String]){
        self.username = username
        self.title = title
        self.image = ""
        self.profilePicture = ""
        self.servings = servings
        self.desc = desc
        self.method = method
        self.ingredients = ingredients
    }
    
    func getProfilePicture() -> (UIImage?){
        if (profilePicture != ""){
            let encodedImage = self.profilePicture
            let data = NSData(base64Encoded: encodedImage)
            let image = UIImage(data: data as! Data)
            return image
        }else{
            return nil
        }
    }
    
    func getImage() -> (UIImage?){
        if(image != ""){
            let encodedImage = self.image
            let data = NSData(base64Encoded: encodedImage)
            let image = UIImage(data: data as! Data)
            return image
        }else{
            return nil
        }
    }
}
