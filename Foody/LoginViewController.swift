//
//  ViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 08/11/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var message: UILabel!
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //MARK: Actions
    @IBAction func loginAction(_ sender: UIButton) {
        let username = "Giovanni"
        let password = "123"
        
        if(self.username.text != ""){
            if(self.password.text != ""){
                if(self.username.text == username){
                    if(self.password.text == password){
                        message.text = "Success"
                        let viewController:UITableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedTableViewController") as UIViewController as! UITableViewController
                        self.present(viewController, animated: false, completion: nil)
                    }else{
                        message.text = "Incorrect Password"
                    }
                }else{
                    message.text = "Incorrect Username"
                }
            }else{
                message.text = "Please enter your password"
            }
        }else{
            message.text = "Please enter your username"
        }
    }
    
    //MARK: Functions
}

