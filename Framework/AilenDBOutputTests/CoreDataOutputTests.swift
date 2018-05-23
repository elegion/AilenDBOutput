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

enum TestToken: String, Token, CustomStringConvertible {
    
    var qos: Qos {
        return Qos.global(async: true)
    }
    
    case test1
    case test2
    
    var description: String {
        return self.rawValue
    }
}

struct TestPayload: CustomStringConvertible {
    var description: String
}

class TestProcessor: Processor {
    
    typealias PayloadType = TestPayload
    
    func process<TokenType>(token: TokenType, object: Any) -> TestPayload? where TokenType : Token {
        guard let string = object as? String else {
            return nil
        }
        
        return TestPayload(description: string)
    }
    
}

class CoreDataOutputTests: XCTestCase {
    
    static var logger: Ailen<TestPayload>? {
        guard let core =  try? AilenPersistentCore() else {
            return nil
        }
            
        let persistent = AilenPersistentStorage(core: core)
        let output = CoreDataOutput(persistent: persistent, lifeTime: nil)
        let logger = Ailen.init(outputs: [output], processors: [TestProcessor()])
        return logger
            
    }
    
    func test_s01_initialization() {
        let expectation1 = expectation(description: "test")
        expectation1.isInverted = true
        CoreDataOutputTests.logger?.log(as: TestToken.test1, value: "someCustomAction")
        wait(for: [expectation1], timeout: 60)
    }
    
}
