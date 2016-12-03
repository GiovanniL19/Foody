//
//  FeedTableViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 02/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    //MARK: Properties
    var posts = [Post]()
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the posts
        loadPosts()
        
        //Set up table UI
        tableSetup()
        
        //Create navigation bar add button with action
        let userIconImage = UIImage(named: "UserIcon")!.withRenderingMode(UIImageRenderingMode.automatic)
        let userButton = UIBarButtonItem(image: userIconImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(FeedTableViewController.goToUser))
        
        let loveIconImage = UIImage(named: "LoveIcon")!.withRenderingMode(UIImageRenderingMode.automatic)
        let loveButton = UIBarButtonItem(image: loveIconImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(FeedTableViewController.goToYum))
        
        
        //Add new button to right of navigation bar
        self.navigationItem.rightBarButtonItem = userButton
        self.navigationItem.leftBarButtonItem = loveButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPost" {
            let postDetailViewController = segue.destination as! PostViewController
            
            if let selectedPostCell = sender as? PostTableViewCell {
                let indexPath = tableView.indexPath(for: selectedPostCell)!
                let selectedPost = posts[indexPath.row - 1]
                postDetailViewController.post = selectedPost
            }
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
    
    func loadPosts(){
        //TODO: build array of objects from json api (Use delegates)
        
        
        //dummy post
        let post = Post(username : "Giovanni Lenguito", title: "Get the family together with this dish", image : "", profilePicture: "", servings: 2, desc: "A romantic meal for 2", method: "You have to do blah blah blah", ingredients: ["1 of something", "another something"]);
        //add dummy post to posts array
        posts += [post]
    }
    
    
    //MARK: Actions
    @IBAction func goToUser(){
        
    }
    
    @IBAction func goToYum(){
        
    }
    
    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1//returns the total number of cells from the array count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            //Gets th estatic add new cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "addNew", for: indexPath)
            //Hide border
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
        }else{
            let cellIdentifier = "PostTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
            
            let post = posts[indexPath.row - 1] //gets post from array (minus 1 because of static row)
            
            //Set cell information
            cell.postTitle.text = post.title
            cell.username.text = post.username
            cell.profileImage.image = post.getProfilePicture()
            
            
            //Convert base64 image to UIImage
            let encodedImage = post.image
            let data = NSData(base64Encoded: encodedImage)
            let image = UIImage(data: data as! Data)
            
            cell.postImage.image = image
            
            //Style the cell
            cell.postImage.layer.cornerRadius = 3;
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2;
            
            //Return the cell
            return cell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
