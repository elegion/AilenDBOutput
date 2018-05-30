//
//  CoreDataOutputTests.swift
//  AilenDBOutputTests
//
//  Created by Arkady Smirnov on 5/23/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import XCTest
import Ailen
@testable import AilenDBOutput



class CoreDataOutputTests: XCTestCase {
    
    enum TestToken: String, Token {
        
        public var qos: Qos {
            return Qos.main(async: false)
        }
        
        case test1
        
        var description: String {
            return "Test1 description"
        }
    }
    
    struct TestPayload: Codable {
        var value: String
    }
    
    class TestProcessor: Processor {
        
        typealias PayloadType = TestPayload
        
        func process<TokenType>(token: TokenType, object: Any) -> TestPayload? where TokenType : Token {
            guard let string = object as? String else {
                XCTFail("value isn't string")
                return nil
            }
            
            return TestPayload(value: string)
        }
        
    }
    
    class TestPersistentStoraging: PersistentStoragingProtocol{
        
        var saveExpectation: XCTestExpectation
        
        init(saveExpectation: XCTestExpectation) {
            self.saveExpectation = saveExpectation
        }
        
        func save(token: String, payload: Codable) {
            saveExpectation.fulfill()
        }
        
        func deleteAll(till date: Date) {
            
        }
    }
    
    
    func test_s01_display() {
        
        let expectation1 = expectation(description: "save data expectation")
        
        let persistent = TestPersistentStoraging(saveExpectation: expectation1)
        let output = CoreDataOutput(persistent: persistent, lifeTime: nil)
        
        
        let message = Message<TestToken, TestPayload>(token: .test1, payload: TestPayload(value: "value"))
        
        output.display(message)
        
        wait(for: [expectation1], timeout: 5)
    }
    
    func test_s02_process() {
        
        let expectation1 = expectation(description: "save data expectation")
        
        let persistent = TestPersistentStoraging(saveExpectation: expectation1)
        let output = CoreDataOutput(persistent: persistent, lifeTime: nil)
        
        
        let message = Message<TestToken, TestPayload>(token: .test1, payload: TestPayload(value: "value"))
        
        output.proccess(message)
        wait(for: [expectation1], timeout: 2)
    }
    
    func test_s03_setTokenLocked() {
        
        let expectation1 = expectation(description: "save data expectation")
        expectation1.isInverted = true
        let persistent = TestPersistentStoraging(saveExpectation: expectation1)
        let output = CoreDataOutput(persistent: persistent, lifeTime: nil)
        
        let message = Message<TestToken, TestPayload>(token: .test1, payload: TestPayload(value: "value"))
        output.set(enabled: false, for: TestToken.test1)
        output.proccess(message)
        wait(for: [expectation1], timeout: 2)
    }
    
}
