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
    
    override func viewDidLayoutSubviews() {
        //Make profile picture round
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
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
    
    func doLogout(){
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
    //MARK: Actions
    @IBAction func deleteUser(_ sender: UIButton) {
        //Delete confirmation alert
        let refreshAlert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //Create URL request
            var request = URLRequest(url: URL(string: "http://localhost:3002/users/" + (self.account?.id)!)!)
            //Set content type
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            //Set request method
            request.httpMethod = "DELETE"
            
            //start of task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                //get response code
                let httpStatus  : HTTPURLResponse? = response as! HTTPURLResponse?
                
                if(httpStatus == nil){
                    //Go back to main thread and perferom a segue to login
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "SERVER ISSUE", message: "Unable to connect to server", preferredStyle: UIAlertControllerStyle.alert)
                        
                        //add action to alert
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                        
                        //Present alert to user
                        self.present(alert, animated: true, completion: nil)                }
                }else if (httpStatus?.statusCode != 200) {  //Check for http errors
                    print("response = \(response)")
                    print("GET should return status code 200. \(httpStatus?.statusCode) was returned")
                    if(httpStatus?.statusCode == 404){
                        //Go back to main thread
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "DELETE ISSUE", message: "Unable to delete user", preferredStyle: UIAlertControllerStyle.alert)
                            
                            //add action to alert
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                            
                            //Present alert to user
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }else{
                    //Go back to main thread
                    DispatchQueue.main.async {
                        //Logout and delete core data
                        self.doLogout()
                    }
                    
                }
            }
            task.resume()

        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
        
    @IBAction func logout(_ sender: UIButton) {
        doLogout()
    }

}
