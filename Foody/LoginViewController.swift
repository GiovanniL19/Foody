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
    @IBOutlet weak var username: InputUITextField!
    @IBOutlet weak var password: InputUITextField!
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
        checkLoginSession()
    }
    
    func checkLoginSession(){
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
        if(self.username.text != ""){
            if(self.password.text != ""){
                //Create URL request
                var request = URLRequest(url: URL(string: "http://localhost:3002/auth?username=" + self.username.text! + "&password=" + self.password.text!)!)
                
                //Set content type
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                
                //Set request method
                request.httpMethod = "GET"
                
                //start of task
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    //get response code
                    let httpStatus  : HTTPURLResponse? = response as! HTTPURLResponse?
                    
                    if(httpStatus == nil){
                        //Go back to main thread and perferom a segue to login
                        DispatchQueue.main.async {
                            self.message.text = "Unable to connect to server"
                        }
                    }else if (httpStatus?.statusCode != 200) {  //Check for http errors
                        print("response = \(response)")
                        print("GET should return status code 200. \(httpStatus?.statusCode) was returned")
                        if(httpStatus?.statusCode == 404){
                            //Go back to main thread and perferom a segue to login
                            DispatchQueue.main.async {
                                self.message.text = "Incorrect credentials"
                                self.username.shake()
                                self.password.shake()
                                
                            }
                        }
                    }else{
                        //Get response
                        let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])  as! [String:AnyObject]
                        
                        //get user object from response
                        let user = jsonResponse?["user"] as! [String:Any]
                        
                        //get values from user json object
                        let fullName = user["fullname"] as! String
                        let profilePicture = user["image"] as! String
                        let email = user["email"] as! String
                        let dateSince = user["memberDate"] as! String
                        let userID = user["id"] as! String
                        
                        //Go back to main thread and perferom a segue to login
                        DispatchQueue.main.async {
                            //User will be logged into their account
                            //Create new user to save in core data
                            
                            let user = self.userService.create(username: self.username.text!, fullname: fullName, email: email, password: self.password.text!, profilePicture: profilePicture, memberDate: dateSince, id: userID)
                            
                            if(user != nil){
                                //Message success to user
                                self.message.text = "Logging you in"
                                self.goToFeed()
                            }else{
                                self.message.text = "There was an error"
                            }
                        }
                    }
                    
                }
                task.resume()
            }else{
                message.text = "Please enter your password"
                password.shake()
            }
        }else{
            message.text = "Please enter your username"
            username.shake()
        }
    }
}

