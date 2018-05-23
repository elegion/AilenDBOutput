//
//  Created by Arkady Smirnov on 5/22/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import CoreData

public class AilenPersistentCore: PersistentStoreCoreProtocol {
    
    // MARK: - Static
    
    private static var managedObjectModel: NSManagedObjectModel {
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
    
    // MARK: - Definitions
    
    private enum Constants {
        static let dataModelName = "com.e-legion.AilenPersistentCoreStorageDataModel"
    }
    
    enum StorageError: Error {
        case unableToLocateDataBase
        
        var localizedDescription: String {
            switch self {
            case .unableToLocateDataBase:                   return "Failure to instantiate data base URL"
            }
        }
    }
    
    // MARK: - Properties
    
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    private var applicationDocumentsDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    private lazy var mainMoc: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    // MARK: - Life cycle
    
    public init() throws {

        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: AilenPersistentCore.managedObjectModel)
        
        let storeURL = applicationDocumentsDirectory?.appendingPathComponent(Constants.dataModelName + ".sqlite")
        guard let storeLocation = storeURL else {
            throw StorageError.unableToLocateDataBase
        }
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeLocation, options: nil)
        } catch {
            try FileManager.default.removeItem(at: storeLocation)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeLocation, options: nil)
        }
    }
    
    // MARK: - Private
    
    private func saveParentContext(completion: ((Error?) -> Void)?) {
        mainMoc.perform {
            do {
                try self.mainMoc.save()
                completion?(nil)
            } catch {
                completion?(error)
            }
        }
    }
    
    // MARK: - PersistentStoreCore
    
    
    public lazy var readManagedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = mainMoc
        return context
    }()
    
    public var writeManagedObjectContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainMoc
        return context
    }
    
    public func saveContext(_ context: NSManagedObjectContext, completion: ((Error?) -> Void)?) {
        guard context.hasChanges else { return }
        
        context.perform {
            do {
                try context.save()
                self.saveParentContext(completion: completion)
            } catch {
                completion?(error)
            }
        }
    }
}
