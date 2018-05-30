//
//  AilenPersistentStorageTests.swift
//  AilenDBOutputTests
//
//  Created by Arkady Smirnov on 5/30/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import XCTest
import Ailen
import CoreData
@testable import AilenDBOutput

class AilenPersistentStorageTests: XCTestCase {
    
    struct TestPayload: Codable {
        var value: String
    }
    
    class TestPersistantStoreCore: PersistentStoreCoreProtocol {
        var readManagedObjectContext: NSManagedObjectContext = {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: TestPersistantStoreCore.managedObjectModel)
            let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            moc.persistentStoreCoordinator = persistentStoreCoordinator
            return moc
        }()
        
        var writeManagedObjectContext: NSManagedObjectContext {
            return self.readManagedObjectContext
        }
        
        var saveExpestation: XCTestExpectation
        
        init(saveExpestation: XCTestExpectation) {
            self.saveExpestation = saveExpestation
        }
        
        func saveContext(_ context: NSManagedObjectContext, completion: ((Error?) -> Void)?) {
            saveExpestation.fulfill()
        }
        
    }
    
    func test_s01_save() {
        let expectation1 = expectation(description: "save data expectation")
        let core = TestPersistantStoreCore(saveExpestation: expectation1)
        
        let ailenPersistentStorage = AilenPersistentStorage(core: core)
        ailenPersistentStorage.save(token: "tokenString", payload: TestPayload(value: "test value"))
        wait(for: [expectation1], timeout: 5)
    }
    
    func test_s02_deleteAll() {
        let expectation1 = expectation(description: "save data expectation")
        let core = TestPersistantStoreCore(saveExpestation: expectation1)
        
        let ailenPersistentStorage = AilenPersistentStorage(core: core)
        ailenPersistentStorage.deleteAll(till: Date())
        wait(for: [expectation1], timeout: 5)
    }

}
