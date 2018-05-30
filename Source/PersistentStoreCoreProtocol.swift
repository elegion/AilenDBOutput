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

extension PersistentStoreCoreProtocol {
    
    // MARK: - Static
    
    public static var managedObjectModel: NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        let messageDescription = NSEntityDescription()
        messageDescription.name = ELNMessage.entityName
        messageDescription.managedObjectClassName = ELNMessage.entityName
        
        let dateDescription = NSAttributeDescription()
        dateDescription.attributeType = .dateAttributeType
        dateDescription.name = "date"
        dateDescription.isOptional = false
        
        let tokenDescription = NSAttributeDescription()
        tokenDescription.attributeType = .stringAttributeType
        tokenDescription.name = "token"
        tokenDescription.isOptional = false
        
        let payloadDescription = NSAttributeDescription()
        payloadDescription.attributeType = .stringAttributeType
        payloadDescription.name = "payload"
        payloadDescription.isOptional = false
        
        messageDescription.properties = [dateDescription, tokenDescription, payloadDescription]
        
        model.entities = [messageDescription]
        
        return model
    }
    
}

