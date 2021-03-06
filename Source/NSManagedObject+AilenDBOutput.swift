//
//  NSManagedObject+AilenDBOutput.swift
//  AilenDBOutput
//
//  Created by Arkady Smirnov on 5/22/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    public static func managedObject<R>(in context: NSManagedObjectContext) -> R {
        return NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: context) as! R
    }
    
    public static var entityName: String {
        return String(describing: self)
    }
    
}
