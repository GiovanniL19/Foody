//
//  ViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 08/11/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var message: UILabel!
    
    //Create instance of UserService
    let userService = UserService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    var accounts: [User] = []
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make navigation bar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        //Removes border (shadow)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //When view has loaded, check if user is logged in
        checkLogin()
    }
    
    func checkLogin(){
        // Read all
        let users : [User] = userService.getAll()
        if(users.count == 1){
            message.text = "Logging you in..."
            goToFeed()
        }
    
    }
    
    func goToFeed(){
        //If a account exisits, bypass login screen
        let viewController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedTableViewController") as UIViewController as! UINavigationController
        
        //Goes to next view
        self.present(viewController, animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func loginAction(_ sender: UIButton) {
        let username = "Giovanni"
        let password = "123"
        
        if(self.username.text != "" || self.password.text != ""){
            if(self.username.text == username){
                if(self.password.text == password){
                    //Create new user to save in core data
                    let user = userService.create(username: username, fullname: "Giovanni Lenguito", email: "giovanni16.gl@gmail.com", password: password, profilePicture: "")
                
                    if(user != nil){
                        //Message success to user
                        message.text = "Success"
                        
                        //Go to feed
                        goToFeed()
                    }else{
                        message.text = "There was an error"
                    }
                    
                }else{
                    message.text = "Incorrect Password"
                }
            }else{
                message.text = "Incorrect Username"
            }
        }else{
            message.text = "Please enter your username and password"
        }
    }
}

