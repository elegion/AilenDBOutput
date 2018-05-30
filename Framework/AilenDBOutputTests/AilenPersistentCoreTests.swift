//
//  AilenDBOutputTests.swift
//  AilenDBOutputTests
//
//  Created by Arkady Smirnov on 5/21/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import XCTest
import CoreData
@testable import AilenDBOutput

class AilenPersistentCoreTests: XCTestCase {
    
    func test_s01_initialization() {
        let core = try? AilenPersistentCore()
        XCTAssertNotNil(core)
    }
    
    func test_s02_readManagedObjectContextGetter() {
        guard let core = try? AilenPersistentCore() else {
            XCTFail("couldn't instatiate AilenPersistentCore")
            return
        }
        XCTAssertNotNil(core.readManagedObjectContext)
    }
    
    func test_s03_writeManagedObjectContextGetter() {
        guard let core = try? AilenPersistentCore() else {
            XCTFail("couldn't instatiate AilenPersistentCore")
            return
        }
        XCTAssertNotNil(core.writeManagedObjectContext)
    }
    
    func test_s04_saveContext() {
        let expectation1 = expectation(description: "context saved")
        
        expectation1.expectedFulfillmentCount = 1
        
        guard let core = try? AilenPersistentCore() else {
            XCTFail("couldn't instatiate AilenPersistentCore")
            return
        }
        
        let context = core.writeManagedObjectContext
        
        let messageObj: AilenDBOutput.ELNMessage = AilenDBOutput.ELNMessage.managedObject(in: context)
        
        messageObj.token = "current.token.description"
        
        messageObj.date = Date()
        messageObj.payload = "current.payload.description"
        
        core.saveContext(context, completion: {
            error in
            if let error = error {
                XCTFail("saveContext throws \(error.localizedDescription)")
            }
            expectation1.fulfill()
        })
        wait(for: [expectation1], timeout: TimeInterval(5))
    }
    
    func test_s05_readContext() {
        guard let core = try? AilenPersistentCore() else {
            XCTFail("couldn't instatiate AilenPersistentCore")
            return
        }
        
        let messagesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ELNMessage.entityName)
        
        let readContext = core.readManagedObjectContext
        do {
            let result = try readContext.fetch(messagesFetch)
            XCTAssert(!result.isEmpty, "result of fetching is empty")
        } catch {
            XCTFail("readContext throws \(error.localizedDescription)")
        }
    }
    
}
