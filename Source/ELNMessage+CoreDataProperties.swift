//
//  ELNMessage+CoreDataProperties.swift
//  ios-logger
//
//  Created by Evgeniy Akhmerov on 27/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//
//

import Foundation
import CoreData


extension ELNMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ELNMessage> {
        return NSFetchRequest<ELNMessage>(entityName: "ELNMessage")
    }

    @NSManaged public var date: Date
    @NSManaged public var payload: String
    @NSManaged public var token: String

}

