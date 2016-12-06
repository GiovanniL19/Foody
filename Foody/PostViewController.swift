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

    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
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
    
}
