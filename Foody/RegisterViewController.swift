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
    var selectedImage : String = ""
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    @IBAction func register(_ sender: Any) {
        
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
