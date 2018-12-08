//
//  User+CoreDataProperties.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 19.11.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var changedAt: NSDate?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var lastName: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var preName: String?
    @NSManaged public var uid: String?
    @NSManaged public var username: String?
    @NSManaged public var usersAddress: UserAddress?

}
