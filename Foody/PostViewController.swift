//
//  PostViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 03/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var by: UILabel!
    @IBOutlet weak var serves: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var difficulty: DifficultyControl!
    @IBOutlet weak var time: TimeControl!
    @IBOutlet weak var method: UITextView!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var ingredientHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var deleteBtn: UIButton!
    let ip = Variables.ip
    
    var post: Post?
    var account : User?

    //Create instance of UserService
    let userService = UserService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(getAccount()){
            populateView()
        }else{
            //Setup alert
            let alert = UIAlertController(title: "ERROR", message: "There was an error getting the user", preferredStyle: UIAlertControllerStyle.alert)
            //Add action to alert
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            //Present alert to user
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK: Functions
    func getAccount() -> Bool{
        //Read all users
        let users : [User] = userService.getAll()
        if(users.count > 0){
            //Get first user
            account = users[0]
            return true
        }else{
            return false
        }
    }
    
    func populateView(){
        if let post = post {
            if(post.username == account?.username){
                deleteBtn.isHidden = false
            }else{
                deleteBtn.isHidden = true
            }
            postImage.image = post.getImage()
            profilePicture.image = post.getProfilePicture()
            
            //Style profile picture
            profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
            
            //Set the values from the post object
            postTitle.text = post.title
            by.text = post.username
            serves.text = String(post.servings)
            
            difficulty.difficulty = post.difficulty
            time.time = post.time
            
            method.text = post.method
            
            //Add header
            let label: UILabel
            label = UILabel(frame: CGRect(x: 5, y: 0, width: 200.00, height: 20.00));
            //set text and style
            label.text = "Ingredients:"
            label.font = label.font.withSize(14)
            label.textColor = UIColor.darkGray
            
            //add ingredient labels to view
            self.ingredientsView.addSubview(label)
            
            for i in 1...post.ingredients.count {
                //Set y position for new input field
                let yAxis : Double = 30.00 * Double(i)
                
                //declare new text field
                let label: UILabel
                
                //create new text field
                if(i == 0){
                    label = UILabel(frame: CGRect(x: 5, y: 0, width: 200.00, height: 20.00));
                    //set text and style
                    label.text = "Ingredients:"
                    label.font = label.font.withSize(14)
                    label.textColor = UIColor.darkGray
                    
                    
                }else{
                    label = UILabel(frame: CGRect(x: 5, y: yAxis, width: 200.00, height: 20.00));
                    //set text and style
                    label.text = "- " + String(post.ingredients[i - 1])
                    label.font = label.font.withSize(13)
                    label.textColor = UIColor.darkGray
                    
                    
                }
                
                //add label to view
                self.ingredientsView.addSubview(label)
                
                //set new height of view to allow scroll
                let newHeight : Int = 25 + Int(yAxis)
                ingredientHeightContraint.constant =  CGFloat(newHeight)
                
            }
            
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    //MARK: Actions
    @IBAction func deletePost(_ sender: Any) {
        //Create URL request
        var request = URLRequest(url: URL(string: ip + "/posts/" + (self.post?.id)!)!)
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
                        let alert = UIAlertController(title: "DELETE ISSUE", message: "Unable to delete post", preferredStyle: UIAlertControllerStyle.alert)
                        
                        //add action to alert
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                        
                        //Present alert to user
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                //Go back to main thread
                DispatchQueue.main.async {
                    //Goes back
                    _ = self.navigationController?.popViewController(animated: true)
                }

            }
            
        }
        task.resume()

    }
    
}
