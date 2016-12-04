//
//  RegisterViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 04/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var username: InputUITextField!
    @IBOutlet weak var fullName: InputUITextField!
    @IBOutlet weak var email: InputUITextField!
    @IBOutlet weak var password: InputUITextField!
    @IBOutlet weak var message: UILabel!
    
    var selectedImage : String = ""
    //Create instance of UserService
    let userService = UserService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: Actions
    @IBAction func register(_ sender: Any) {
        //create URL request
        var request = URLRequest(url: URL(string: "http://localhost:3002/users")!)
        
        //Set content type
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //set request method
        request.httpMethod = "POST"
        
        let dictionary = ["username": username.text, "image": String(selectedImage), "fullname": fullName.text, "email": email.text, "password": password.text]
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])

        
        //start of task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { //Check for network error
                print("error=\(error)")
                return
            }
            
            let httpStatus = response as! HTTPURLResponse
            
            if (httpStatus.statusCode != 201) {  //Check for http errors
                print("response = \(response)")
                print("Post should return status code 201. \(httpStatus.statusCode) was returned")
            }else{
                //Get response
                //let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                
                //Got back to main thread and perferom a segue to login
                DispatchQueue.main.async {
                    //User will be logged into their account
                    //Create new user to save in core data
                    let user = self.userService.create(username: self.username.text!, fullname: self.fullName.text!, email: self.email.text!, password: self.password.text!, profilePicture: self.selectedImage)
                    
                    if(user != nil){
                        //Message success to user
                        self.message.text = "Logging you in"
                        
                        //setup view controller for feed
                        let viewController : UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedTableViewController") as UIViewController as! UINavigationController
                        
                        //Goe to feed
                        self.present(viewController, animated: true, completion: nil)
                    }else{
                        self.message.text = "There was an error"
                    }
                }
            }
            
        }
        task.resume()
    }
    
    @IBAction func addImage(_ sender: Any) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        
        present(imagePickerController, animated: true, completion: nil)

    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage //selected image
        
        //Encode image to base64
        //Convert imgage to NSData
        let pictureData = UIImagePNGRepresentation(image)
        
        selectedImage = (pictureData?.base64EncodedString(options: []))!
        dismiss(animated: true, completion: nil)
    }

}
