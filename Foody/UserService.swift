//
//  UserService.swift
//  Foody
//
//  Created by Giovanni Lenguito on 04/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import CoreData

class UserService{
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        //Initilise service by setting context
        self.context = context
    }
    
    //Creates new user
    func create(username: String, fullname: String, email: String, password: String, profilePicture: String, memberDate: String, id: String) -> User? {
        
        //Declare new user object
        let newUser = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: context) as! User
        
        //Set new user values
        newUser.username = username
        newUser.fullname = fullname
        newUser.email = email
        newUser.password = password
        newUser.profilePicture = profilePicture
        newUser.memberDate = memberDate
        newUser.id = id
        
        //Save changes
        if(saveChanges()){
            //Return new user object
            return newUser
        }else{
            return nil
        }
    }
    
    // Gets all users
    func getAll() -> [User]{
        //returns all users
        return get(withPredicate: NSPredicate(value:true))
    }
    
    // Gets all with predicate.
    func get(withPredicate queryPredicate: NSPredicate) -> [User]{
        //Decalre fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: User.entityName)
        
        //Set predicate
        fetchRequest.predicate = queryPredicate
        
        do {
            //Make fetch and return as User
            return try context.fetch(fetchRequest) as! [User]
            
        } catch let error as NSError {
            //If there was an error...
            print("Could not delete \(error), \(error.userInfo)")
            return [User]()
        }
    }
    
    //Gets user by id
    func getById(id: NSManagedObjectID) -> User? {
        //Returns user by id
        return context.object(with: id) as? User
    }
    
    //Updates user
    func update(updatedUser: User) -> (Bool){
        //If get user by id returns true then set new values
        if let user = getById(id: updatedUser.objectID){
            //Set new values of user
            user.username = updatedUser.username
            user.fullname = updatedUser.fullname
            user.email = updatedUser.email
            user.password = updatedUser.password
            user.profilePicture = updatedUser.profilePicture
            user.id = updatedUser.id
            
            if(saveChanges()){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    //Deletes user
    func delete(id: NSManagedObjectID) -> (Bool){
        //If user by id is found
        if let userToDelete = getById(id: id){
            //Delete user
            context.delete(userToDelete)
            if(saveChanges()){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    //Saves all changes
    func saveChanges() -> (Bool){
        do{
            //Executes save
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
            return false
        }
    }
}
