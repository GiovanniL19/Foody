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
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            postImage.image = post.getImage()
            profilePicture.image = post.getProfilePicture()
            
            //Style profile picture
            profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
            
            postTitle.text = post.title
            by.text = post.username
            serves.text = String(post.servings)
            postDescription.text = post.desc
            
        }
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
