//
//  Users+CoreDataProperties.swift
//  ToDo-App
//
//  Created by Samxal Quliyev  on 10.10.24.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastname: String?

}

extension Users : Identifiable {

}
