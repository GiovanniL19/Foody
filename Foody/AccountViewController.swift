//
//  AccountViewController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 04/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {
    //MARK: Properties
    var accounts: [NSManagedObject] = []
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var privateAccount: UISwitch!
    @IBOutlet weak var accountInfo: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get account
        getAccount()
        
        //Setup save button
        //Create navigation bar add button with action
        let checkIconImage = UIImage(named: "Check")!.withRenderingMode(UIImageRenderingMode.automatic)
        let saveBtn = UIBarButtonItem(image: checkIconImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AccountViewController.save))
        
        //Add new button to right of navigation bar
        self.navigationItem.rightBarButtonItem = saveBtn

    }
    func save(){
        //TODO: Do save here
    }
    
    func getAccount(){
        //Declare context for core data
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        //Declare fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        
        //Try and get accounts
        do {
            accounts = try context.fetch(fetchRequest)
            
            //get first (and only) account in array
            let account = accounts[0]
            
            //get and set values
            username.text = account.value(forKeyPath: "username") as? String
            
            email.text = account.value(forKeyPath: "email") as? String
            
            password.text = account.value(forKeyPath: "password") as? String
            
            fullName.text = account.value(forKeyPath: "fullname") as? String
            
            
        
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Actions
    @IBAction func logout(_ sender: UIButton) {
        //Declare context for core data
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext

        
        //Declare fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        
        //Declare batch request
        let deleteAllAccounts = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            //Execute delete
            try context.execute(deleteAllAccounts)
            
            //Setup controller
            let viewController : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            
            //Goes to next view
            self.present(viewController, animated: true, completion: nil)

            
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
