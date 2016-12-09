//
//  User.swift
//  Foody
//
//  Created by Giovanni Lenguito on 21/11/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject {
    //MARK: Properties
    @NSManaged var username: String?
    @NSManaged var fullname: String?
    @NSManaged var email: String?
    @NSManaged var password: String?
    @NSManaged var profilePicture: String?
    @NSManaged var memberDate: String?
    @NSManaged var id: String?

    static let entityName = "User"
}
