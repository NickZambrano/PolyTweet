//
//  User+CoreDataProperties.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 13/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var img: NSData?
    @NSManaged public var mail: String?
    @NSManaged public var lname: String?
    @NSManaged public var password: String?
    @NSManaged public var fname: String?
    @NSManaged public var appartient: Departement?
    @NSManaged public var send: NSSet?

}

// MARK: Generated accessors for send
extension User {

    @objc(addSendObject:)
    @NSManaged public func addToSend(_ value: Message)

    @objc(removeSendObject:)
    @NSManaged public func removeFromSend(_ value: Message)

    @objc(addSend:)
    @NSManaged public func addToSend(_ values: NSSet)

    @objc(removeSend:)
    @NSManaged public func removeFromSend(_ values: NSSet)

}
