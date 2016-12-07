//
//  NewPostTableViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 03/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class NewPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //MARK: Properties
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var method: UITextView!
    @IBOutlet weak var ingredientsScrollView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var difficultyControl: DifficultyControl!
    @IBOutlet weak var timeControl: TimeControl!
    @IBOutlet weak var servings: UIPickerView!
    
    var ingredientCount : Int = 0
    var selectedImage : String = ""
    var account : User?
    var servingsData : [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    var selectedServing : String = ""
    
    //Create instance of UserService
    let userService = UserService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up picker
        self.servings.dataSource = self
        self.servings.delegate = self
        
        //Create navigation bar add button with action
        let addButton = UIBarButtonItem(title: "ADD", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewPostTableViewController.addPost))
        
        //Add new button to right of navigation bar
        self.navigationItem.rightBarButtonItem = addButton
        
        //Set up table UI
        tableSetup()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44;
        
        //Get account
        getAccount()
    }
    
    func getAccount(){
        // Read all
        let users : [User] = userService.getAll()
        if(users.count == 1){
            //get first (and only) account in array
            account = users[0]
        }
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
        textField.placeholder = "Ingredient " + String(ingredientCount + 1) +  "..."
        //incerement number of ingredients added
        ingredientCount += 1
        
        //give input field a tag
        textField.tag = 0000 + ingredientCount
        
        //add textfield to view
        self.ingredientsScrollView.addSubview(textField)
        
        //set new height of view to allow scroll
        let newHeight : Int = 50 + Int(yAxis)
        viewHeight.constant =  CGFloat(newHeight)
        
        //Scroll to bottom of scroll view
        let bottomOffset = CGPoint(x: 0, y: CGFloat(newHeight) - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
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
                if(!textField.text!.isEmpty){
                    ingredients.append(textField.text!)
                }
            }
        }
        
        //Create URL request
        var request = URLRequest(url: URL(string: "http://localhost:3002/posts")!)
        
        //Set content type
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //Set request method
        request.httpMethod = "POST"
        
        //Create dictionary
        let dictionary : [String : Any] = ["title": postTitle.text, "username": account?.username, "profilePicture": account?.profilePicture, "image": selectedImage, "desc": self.postDescription.text, "servings": selectedServing, "method": method.text, "ingredients": ingredients, "difficulty": String(difficultyControl.difficulty), "time": String(timeControl.time)]
    
        //Add json to body
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        //start of task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //get response code
            let httpStatus = response as? HTTPURLResponse
            
            if (httpStatus?.statusCode != 201) {  //Check for http errors
                print("response = \(response)")
                print("Post should return status code 201. \(httpStatus?.statusCode) was returned")
            }else{
                //Go back to main thread
                DispatchQueue.main.async {
                    //Goes back
                    self.navigationController?.popViewController(animated: true)
                }

            }
        }
        task.resume()
        
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
        let pictureData = UIImageJPEGRepresentation(image, 10.0)
        
        selectedImage = (pictureData?.base64EncodedString())!
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Data Sources
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return servingsData.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return servingsData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  -> String? {
        selectedServing =  servingsData[row]
        return servingsData[row]
    }
}
