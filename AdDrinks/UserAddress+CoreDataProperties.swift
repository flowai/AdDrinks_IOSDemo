//
//  UserAddress+CoreDataProperties.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 19.11.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//
//

import Foundation
import CoreData


extension UserAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAddress> {
        return NSFetchRequest<UserAddress>(entityName: "UserAddress")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var housenumber: String?
    @NSManaged public var postalCode: Int16
    @NSManaged public var street: String?

}
