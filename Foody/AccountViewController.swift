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
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        getAccount()
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
            
            //get values
            let username = account.value(forKeyPath: "username") as? String
        
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
