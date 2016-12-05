//
//  NewPostTableViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 03/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class NewPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var servings: UITextField!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var method: UITextView!
    @IBOutlet weak var ingredientsScrollView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ingredientCount : Int = 0
    var selectedImage : String = ""
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create navigation bar add button with action
        let addButton = UIBarButtonItem(title: "ADD", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewPostTableViewController.addPost))
        
        //Add new button to right of navigation bar
        self.navigationItem.rightBarButtonItem = addButton
        
        //Set up table UI
        tableSetup()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44;
    }
    
    func tableSetup(){
        //Sets minimum row height for static table
        self.tableView.estimatedRowHeight = 38
        
        //Allows row height to change dynamicly
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Hide table seperator
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //Hide navigation bar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    //MARK: Actions
    @IBAction func addIngredient(_ sender: UIButton) {
        //Set y position for new input field
        let yAxis : Double = 50.00 * Double(ingredientCount)
        
        //declare new text field
        let textField: UITextField
        
        //create new text field
        if(ingredientCount == 0){
            textField = UITextField(frame: CGRect(x: 10, y: 0, width: 200.00, height: 40.00));
        }else{
            textField = UITextField(frame: CGRect(x: 10, y: yAxis, width: 200.00, height: 40.00));
        }
        
        //set placeholder text
        textField.placeholder = "Ingredient " + String(ingredientCount) +  "..."
        //incerement number of ingredients added
        ingredientCount += 1
        
        //give input field a tag
        textField.tag = 0000 + ingredientCount
        
        //add textfield to view
        self.ingredientsScrollView.addSubview(textField)
        
        //set new height of view to allow scroll
        let newHeight : Int = 50 + Int(yAxis)
        viewHeight.constant =  CGFloat(newHeight)
    }
    
    @IBAction func addImage(_ sender: Any) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    //When add has been clicked, this function is called
    @IBAction func addPost(){
        var ingredients : [String] = []
        
        //Get ingredients
        for i in 0...ingredientCount{
            //check if field exists
            if let textField = self.view.viewWithTag(0000 + i) as? UITextField {
                //add ingredient to array
                ingredients.append(textField.text!)
            }
        }
        
        //Make jsonobject
        
        
        //Make post request
        
        
        
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
