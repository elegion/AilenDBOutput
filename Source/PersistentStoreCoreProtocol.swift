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

public protocol PersistentStoreCoreProtocol {
    var readManagedObjectContext: NSManagedObjectContext { get }
    var writeManagedObjectContext: NSManagedObjectContext { get }
    
    func saveContext(_ context: NSManagedObjectContext, completion: ((Error?) -> Void)?)
}
