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
    
    var accounts: [NSManagedObject] = []
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLogin()
    }
    
    func checkLogin(){
        //Declare context for core data
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        //Declare fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        
        //Try and get accounts
        do {
            accounts = try context.fetch(fetchRequest)
            print(accounts.count)
            if(accounts.count == 1){
                message.text = "Logging you in..."
                //If a account exisits, bypass login screen
                let viewController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedTableViewController") as UIViewController as! UINavigationController
                
                //Goes to next view
                self.present(viewController, animated: true, completion: nil)

                
            }else if (accounts.count >= 2){
                //If multiple accounts exisits, delete all accounts (There was an error)
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            message.text = "An error occured"
        }
    }
    
    //MARK: Actions
    @IBAction func loginAction(_ sender: UIButton) {
        let username = "Giovanni"
        let password = "123"
        
        if(self.username.text != ""){
            if(self.password.text != ""){
                if(self.username.text == username){
                    if(self.password.text == password){
                        //Message success to user
                        message.text = "Success"
                        
                        //Declare context for core data
                        guard let appDelegate =
                            UIApplication.shared.delegate as? AppDelegate else {
                                return
                            }
                        let context = appDelegate.persistentContainer.viewContext
                        
                        
                        //Declare entity
                        let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)!
                        
                        //Declare user
                        let user = NSManagedObject(entity: entity, insertInto: context)
                        
                        do {
                            //Set values
                            user.setValue(username, forKeyPath: "username")
                            user.setValue(password, forKeyPath: "password")
                            
                            //UNCOMMENT WHEN GOT DATA
                            /*
                             user.setValue(fullname, forKeyPath: "fullname")
                             user.setValue(email, forKeyPath: "email")
                             user.setValue(profilePicture, forKeyPath: "profilePicture")
                             user.setValue(memberDate, forKeyPath: "memberDate")
                             */

                            
                            //save the account
                            try context.save()
                            
                            //Setup controller
                            let viewController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedTableViewController") as UIViewController as! UINavigationController
                            
                            //Goes to next view
                            self.present(viewController, animated: false, completion: nil)
                            
                        } catch let error as NSError {
                            //Catch error and print to user and console
                            print("Unable to save account \(error), \(error.userInfo)")
                            message.text = "There was an error"
                        }
                        
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
}

