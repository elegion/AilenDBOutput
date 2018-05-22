//
//  Created by Evgeniy Akhmerov on 14/12/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData
import Ailen

public protocol AilenPersistentStorageDelegate: class {
    func storageDidFailSaving(_ persistentStorage: AilenPersistentStorage, with error: Error)
    func storageDidFailFetchMessages(_ persistentStorage: AilenPersistentStorage, predicate: NSPredicate?, with error: Error)
}

public class AilenPersistentStorage: PersistentStoraging {
    
    // MARK: - Properties
    
    private let core: PersistentStoreCore
    public var delegate: AilenPersistentStorageDelegate?
    
    // MARK: - Life cycle
    
    public init(core: PersistentStoreCore) {
        self.core = core
    }
    
    // MARK: - Private
    
    
    private func fetchMessages(predicate: NSPredicate?, in context: NSManagedObjectContext? = nil) -> [ELNMessage]? {
        let context = context ?? core.readManagedObjectContext
        
        let request = NSFetchRequest<ELNMessage>(entityName: ELNMessage.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = predicate
        let result: [ELNMessage]?
        do {
            result = try context.fetch(request)
        } catch {
            delegate?.storageDidFailFetchMessages(self, predicate: predicate, with: error)
            result = nil
        }
        return result
    }
    
    private func removeMessages(predicate: NSPredicate? = nil, in context: NSManagedObjectContext? = nil) {
        let context = context ?? core.writeManagedObjectContext
        
        if let messages = fetchMessages(predicate: predicate, in: context) {
            messages.forEach(context.delete)
            
            core.saveContext(context) {
                [weak self] (error) in
                if let _error = error {
                    self?.handleSaveContextError(_error)
                }
            }
        }
    }
    
    private func fetchAll() -> [ELNMessage]? {
        return fetchMessages(predicate: nil)
    }
    
    private func handleSaveContextError(_ error: Error) {
        delegate?.storageDidFailSaving(self, with: error)
    }
    
    // MARK: - PersistentStoraging
    
    public func save<TokenType: CustomStringConvertible, PayloadType: CustomStringConvertible>(_ messages: [Message<TokenType, PayloadType>]) {
        let context = core.writeManagedObjectContext
        
        messages.forEach {
            (current) in
           
            let messageObj: ELNMessage = ELNMessage.managedObject(in: context)
            
            messageObj.token = current.token.description
            
            messageObj.date = Date()
            messageObj.payload = current.payload.description
        }
        
        core.saveContext(context) {
            [weak self] (error) in
            if let _error = error {
                self?.handleSaveContextError(_error)
            }
        }
    }
    
    public func deleteAll(till date: Date) {
        let predicate = NSPredicate(format: "date < %@", argumentArray: [date])
        
        removeMessages(predicate: predicate)
    }
}
