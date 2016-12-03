//
//  NewPostTableViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 03/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class NewPostTableViewController: UITableViewController {
    //MARK: Properties
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var servings: UITextField!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var method: UITextView!
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create navigation bar add button with action
        let addButton = UIBarButtonItem(title: "ADD", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewPostTableViewController.addPost))
        
        
        //Add new button to right of navigation bar
        self.navigationItem.rightBarButtonItem = addButton
        
        //Set up table UI
        tableSetup()
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
    
    //When add has been clicked, this function is called
    @IBAction func addPost(){
        
    }
    
    
    /*
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

     */
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
