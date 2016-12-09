//
//  YumTableViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 08/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class YumTableViewController: UITableViewController {
    //MARK: Properties
    var yums : [Post] = []
    var account : User?
    @IBOutlet weak var loadingView: UIView!
    
    //Create instance of UserService
    let userService = UserService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get account
        if(!getAccount()){
            //Setup alert
            let alert = UIAlertController(title: "ERROR", message: "There was an error getting the user", preferredStyle: UIAlertControllerStyle.alert)
            //Add action to alert
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            //Present alert to user
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //start to load the posts
        getAllPosts()
        tableSetup()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //sends post to view
        if segue.identifier == "ShowYum" {
            let postDetailViewController = segue.destination as! PostViewController
            
            if let selectedPostCell = sender as? PostTableViewCell {
                let indexPath = tableView.indexPath(for: selectedPostCell)!
                let selectedPost = yums[indexPath.row]
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
    
    func getAllPosts(){
        //Show loading
        self.loadingView.isHidden = false
        //Reload table
        self.tableView.reloadData()
        //Create URL request
        var request = URLRequest(url: URL(string: "http://localhost:3002/yums/" + (account?.id)!)!)
        
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
                //Runs the following code on main thread
                DispatchQueue.main.async{
                    //Get response
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])  as! [String:AnyObject]
                    
                    //get user object from response
                    let postsJson = jsonResponse?["posts"]
                    
                    //Loop through json posts
                    //Empty posts
                    self.yums = []
                    
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
                        self.yums += [post]
                    }
                    
                    //Update table with new data
                    self.tableView.reloadData()
                    //Hide loading
                    self.loadingView.isHidden = true
                }
            }
            
        }
        task.resume()
    }

    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yums.count
    }
    
    func getAccount() -> Bool{
        // Read all
        let users : [User] = userService.getAll()
        if(users.count > 0){
            //get first account in array
            account = users[0]
            return true
        }else{
            return false
        }
    }

    func selectedForYum(sender: UIButton!) {
        //save the post in core data
        let postsIndex = sender.tag
        let postID = yums[postsIndex].id
        
        
        //Create URL request
        var request = URLRequest(url: URL(string: "http://localhost:3002/yums")!)
        
        //Set content type
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //Set request method
        request.httpMethod = "POST"
        
        //Create dictionary
        let userId = account?.id;
        let dictionary : [String : Any] = ["user": userId, "post": postID]
        
        //Add json to body
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        //start of task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //get response code
            let httpStatus = response as? HTTPURLResponse
            
            if(httpStatus?.statusCode == 201){
                //Runs the following code on main thread
                DispatchQueue.main.async{
                    let heart = UIImage(named: "LoveIconFill") as UIImage?
                    sender.setImage(heart, for: .normal)
                }
            }else if (httpStatus?.statusCode == 200) {
                //Runs the following code on main thread
                DispatchQueue.main.async{
                    let heart = UIImage(named: "LoveIcon") as UIImage?
                    sender.setImage(heart, for: .normal)
                }
            }else{
                print("response = \(response)")
                print("Post should return status code 200. \(httpStatus?.statusCode) was returned")
                
                //Setup alert
                let alert = UIAlertController(title: "ERROR", message: "An error occured", preferredStyle: UIAlertControllerStyle.alert)
                //Add action to alert
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                
                //Present alert to user
                self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PostTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        
        let post = yums[indexPath.row] //gets post from array
        
        //Set cell information
        cell.postTitle.text = post.title
        cell.postDescription.text = post.desc
        
        if(!post.profilePicture.isEmpty){
            cell.profileImage.image = post.getProfilePicture()
        }
        
        //Give yum button a tag
        cell.yumButton.tag = indexPath.row;
        
        //Add action to yum button
        cell.yumButton.addTarget(self, action: #selector(FeedTableViewController.selectedForYum(sender:)), for: .touchUpInside)

        
        cell.postImage.image = post.getImage()
        
        //Style the cell
        cell.postImage.layer.cornerRadius = 3;
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2;
        
        //Return the cell
        return cell
    }


}
