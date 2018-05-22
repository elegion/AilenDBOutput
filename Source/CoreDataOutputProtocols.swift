//
//  CoreDataOutputProtocols.swift
//  Ailen
//
//  Created by Arkady Smirnov on 2/1/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import Foundation
import CoreData
import Ailen

public protocol PersistentStoreCore {
    var managedObjectModel: NSManagedObjectModel { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
    var readManagedObjectContext: NSManagedObjectContext { get }
    var writeManagedObjectContext: NSManagedObjectContext { get }
    var currentManagedObjectContext: NSManagedObjectContext { get }
    
    func saveContext(_ context: NSManagedObjectContext, completion: ((Error?) -> Void)?)
}

public protocol PersistentStoraging {
    func save<TokenType: CustomStringConvertible, PayloadType: CustomStringConvertible>(_ messages: [Message<TokenType, PayloadType>])
    func deleteAll(till date: Date)
}
