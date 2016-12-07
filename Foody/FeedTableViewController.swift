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
    @IBOutlet weak var loadingView: UIView!
    var posts = [Post]()
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup talbe
        self.tableSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //start to load the posts
        getAllPosts()
    }
    
    func getAllPosts(){
        loadingView.isHidden = false
        
        //Empty posts
        posts = []
        //Reload table
        self.tableView.reloadData()
        //Create URL request
        var request = URLRequest(url: URL(string: "http://localhost:3002/posts")!)
        
        //Set content type
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //Set request method
        request.httpMethod = "GET"
        
        //start of task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //get response code
            let httpStatus : HTTPURLResponse? = response as! HTTPURLResponse?
            
            if(httpStatus == nil){
                let alert = UIAlertController(title: "SERVER ISSUE", message: "Unable to connect to server", preferredStyle: UIAlertControllerStyle.alert)
                
                //add action to alert
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                
                //Present alert to user
                self.present(alert, animated: true, completion: nil)
            }else if (httpStatus?.statusCode != 200) {  //Check for http errors
                print("response = \(response)")
                print("GET should return status code 200. \(httpStatus?.statusCode) was returned")
                if(httpStatus?.statusCode == 404){
                    //Go back to main thread and perferom a segue to login
                    DispatchQueue.main.async {
                        //Create alert
                        let alert = UIAlertController(title: "ERROR", message: "Error getting posts", preferredStyle: UIAlertControllerStyle.alert)
                        
                        //add action to alert
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                        
                        //Present alert to user
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                //Get response
                let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])  as! [String:AnyObject]
                
                //get user object from response
                let postsJson = jsonResponse?["posts"]
                
                //Loop through json posts
                for post in postsJson as! [Dictionary<String, AnyObject>] {
                    let postTitle = post["title"] as! String
                    let servings = post["servings"] as! String
                    let postDescription = post["desc"] as! String
                    let method = post["method"] as! String
                    let ingredients = post["ingredients"] as! [String]
                    let difficulty = post["difficulty"] as! String
                    let time = post["time"] as! String
                    let image = post["image"] as! String
                    let profilePicture = post["profilePicture"] as! String
                    let username = post["username"] as! String
                    let id = post["id"] as! String
                    
                    let post = Post(username : username, title: postTitle, image : image, profilePicture: profilePicture, servings: Int(servings)!, desc: postDescription, method: method, ingredients: ingredients);
                    post.difficulty = Int(difficulty)!
                    post.time = Int(time)!
                    post.id = id
                    
                    //add post to array
                    self.posts += [post]
                }
                
                //Update table with data
                DispatchQueue.main.async{
                    //update table
                    self.tableView.reloadData()
                    self.loadingView.isHidden = true
                }

            }
            
        }
        task.resume()
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
            
            if(!post.profilePicture.isEmpty){
                cell.profileImage.image = post.getProfilePicture()
            }
            
            cell.postImage.image = post.getImage()
            
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
