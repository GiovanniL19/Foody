//
//  AccountViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 04/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {
    //MARK: Properties
    var accounts: [NSManagedObject] = []
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var privateAccount: UISwitch!
    @IBOutlet weak var accountInfo: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var account : User?
    
    //Create instance of UserService
    let userService = UserService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get account
        getAccount()
        
        //Setup save button
        //Create navigation bar add button with action
        let checkIconImage = UIImage(named: "Check")!.withRenderingMode(UIImageRenderingMode.automatic)
        let saveBtn = UIBarButtonItem(image: checkIconImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AccountViewController.save))
        
        //Add new button to right of navigation bar
        self.navigationItem.rightBarButtonItem = saveBtn

    }
    func save(){
        //Save changes
        account?.username = username.text
        account?.password = password.text
        account?.email = email.text
        account?.fullname = fullName.text
        account?.profilePicture = ""
        
        if(userService.update(updatedUser: account!)){
            //Create alert
            let alert = UIAlertController(title: "SAVED", message: "Account settings saved", preferredStyle: UIAlertControllerStyle.alert)
            
            //add action to alert
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            //Present alert to user
            self.present(alert, animated: true, completion: nil)
        }else{
            //Create alert
            let alert = UIAlertController(title: "ERROR", message: "Was unable to log you out, please try again", preferredStyle: UIAlertControllerStyle.alert)
            
            //add action to alert
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            //Present alert to user
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getAccount(){
        // Read all
        let users : [User] = userService.getAll()
        if(users.count == 1){
            //get first (and only) account in array
            account = users[0]
            
            //get and set values
            username.text = account?.username
            email.text = account?.email
            password.text = account?.password
            fullName.text = account?.fullname
            
            if(account?.profilePicture != ""){
                let encodedImage = account?.profilePicture
                let data = NSData(base64Encoded: encodedImage!)
                let image = UIImage(data: data as! Data)
                profilePicture.image = image
            }
        }
    }
    
    //MARK: Actions
    @IBAction func logout(_ sender: UIButton) {
        if(userService.delete(id: (account?.objectID)!)){
            //Setup controller
            let viewController : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            
            //Goes to next view
            self.present(viewController, animated: true, completion: nil)
        }else{
            
            //Create alert
            let alert = UIAlertController(title: "ERROR", message: "Was unable to log you out, please try again", preferredStyle: UIAlertControllerStyle.alert)
            
            //add action to alert
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            //Present alert to user
            self.present(alert, animated: true, completion: nil)
        }
    }

}
