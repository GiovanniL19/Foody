//
//  AccountViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 04/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    var accounts: [NSManagedObject] = []
    
    @IBOutlet weak var username: InputUITextField!
    @IBOutlet weak var email: InputUITextField!
    @IBOutlet weak var password: InputUITextField!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var privateAccount: UISwitch!
    @IBOutlet weak var accountInfo: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var selectedImage : String = ""
    var account : User?
    
    //Create instance of UserService
    let userService = UserService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Link gesture 
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tapGesture)
        
        //Get account
        getAccount()
        
        //Setup save button
        //Create navigation bar add button with action
        let checkIconImage = UIImage(named: "Check")!.withRenderingMode(UIImageRenderingMode.automatic)
        let saveBtn = UIBarButtonItem(image: checkIconImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AccountViewController.saveAccount))
        
        //Add new button to right of navigation bar
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    override func viewDidLayoutSubviews() {
        //Make profile picture round
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
    }
    
    func pulseProfilePicture(numberOfpulses : Float){
        //Initialise pulse
        let pulse = Pulse(numberPulses: numberOfpulses, radius: 90, position: profilePicture.center, duration : 0, colour : UIColor.green.cgColor)
        //Add pulse to profile picture
        self.view.layer.insertSublayer(pulse, below: profilePicture.layer)
        
    }
    
    func saveAccount(){
        if(self.username.text != ""){
            if(self.email.text != ""){
                if(self.password.text != ""){
                    pulseProfilePicture(numberOfpulses: 5)
                    //This saves core data and makes PUT request to save online
                    //Create URL request
                    var request = URLRequest(url: URL(string: "http://localhost:3002/users/" + (account?.id)!)!)
                    
                    //Set content type
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    
                    //Set request method
                    request.httpMethod = "PUT"
                    
                    //Create json via dictionary
                    var image : String
                    if(selectedImage.isEmpty){
                        image = (self.account?.profilePicture)!
                    }else{
                        image = selectedImage
                    }
                    
                    let dictionary = ["username": self.username.text, "image": String(image), "fullname": self.fullName.text, "email": self.email.text, "password": self.password.text, "memberDate": self.account?.memberDate]
                    
                    //Add json to body
                    request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                    
                    
                    //start of task
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        //get response code
                        let httpStatus = response as? HTTPURLResponse
                        
                        if (httpStatus?.statusCode != 200) {  //Check for http errors
                            print("response = \(response)")
                            print("Post should return status code 200. \(httpStatus?.statusCode) was returned")
                            //Go back to main thread and perferom a segue to login
                            DispatchQueue.main.async {
                                //Create alert
                                let alert = UIAlertController(title: "ERROR", message: "Error updating account", preferredStyle: UIAlertControllerStyle.alert)
                                
                                //add action to alert
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                
                                //Present alert to user
                                self.present(alert, animated: true, completion: nil)
                            }
                        }else{
                            DispatchQueue.main.async {
                                //Save changes
                                self.account?.username = self.username.text
                                self.account?.password = self.password.text
                                self.account?.email = self.email.text
                                self.account?.fullname = self.fullName.text
                                self.account?.profilePicture = image
                                
                                if(self.userService.update(updatedUser: self.account!)){
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
                        }
                        
                    }
                    task.resume()
                }else{
                    self.password.shake()
                }
            }else{
                self.email.shake()
            }
        }else{
         self.username.shake()
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
    @IBAction func changeProfilePicture(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
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

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage //selected image
        profilePicture.image = image
        //Encode image to base64
        //Convert imgage to NSData
        let pictureData = UIImagePNGRepresentation(image)
        
        selectedImage = (pictureData?.base64EncodedString(options: []))!
        dismiss(animated: true, completion: nil)
    }
}
