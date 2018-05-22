//
//  AilenDBOutputTests.swift
//  AilenDBOutputTests
//
//  Created by Arkady Smirnov on 5/21/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import XCTest
@testable import AilenDBOutput

class AilenPersistentCoreTests: XCTestCase {
    
    func testInitialization() {
        let core = try? AilenPersistentCore(storeURL: nil)
        XCTAssertNotNil(core)
    }
    
    func testReadManagedObjectContextGetter() {
        guard let core = try? AilenPersistentCore(storeURL: nil) else {
            XCTAssert(false, "couldn't instatiate AilenPersistentCore")
            return
        }
        XCTAssertNotNil(core.readManagedObjectContext)
    }
    
    func testWriteManagedObjectContextGetter() {
        guard let core = try? AilenPersistentCore(storeURL: nil) else {
            XCTAssert(false, "couldn't instatiate AilenPersistentCore")
            return
        }
        XCTAssertNotNil(core.writeManagedObjectContext)
    }
    
    func testSaveContext() {
        guard let core = try? AilenPersistentCore(storeURL: nil) else {
            XCTAssert(false, "couldn't instatiate AilenPersistentCore")
            return
        }
        
        let context = core.writeManagedObjectContext
        
        core.saveContext(context, completion: {
            error in
            XCTAssert(false, "saveContext throws \(error?.localizedDescription ?? "error")")
        })
    }
    
}
