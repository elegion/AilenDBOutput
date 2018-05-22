//
//  NSManagedObject+AilenDBOutput.swift
//  AilenDBOutput
//
//  Created by Arkady Smirnov on 5/22/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    public static func managedObject<Result: NSManagedObject>(in context: NSManagedObjectContext) -> Result {
        return NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: context) as! Result
    }
    
    public static var entityName: String {
        return String(describing: self)
    }
    
}
