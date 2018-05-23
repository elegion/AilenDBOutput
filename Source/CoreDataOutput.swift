//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData
import Ailen

public class CoreDataOutput: DefaultOutput {
    
    // MARK: - Definitions
    
    public struct Settings {
        public let lifeTime: TimeInterval?
        
        public init(lifeTime: TimeInterval? = nil) {
            self.lifeTime = lifeTime
        }
    }
    
    // MARK: - Properties
    
    private let settings: Settings
    private let persistent: PersistentStoragingProtocol
    
    // MARK: - Life cycle
    
    public init(settings: Settings, persistent: PersistentStoragingProtocol) {
        self.settings = settings
        self.persistent = persistent
        
        super.init()
        
    }
    
    public convenience init(persistent: PersistentStoragingProtocol, lifeTime: TimeInterval? = nil) {
        self.init(settings: CoreDataOutput.Settings(lifeTime: lifeTime), persistent: persistent)
    }
    
    // MARK: - Output
    
    open override func display<TokenType: CustomStringConvertible, PayloadType: CustomStringConvertible>(_ message: Message<TokenType, PayloadType>) {
        if let lifeTimeInterval = settings.lifeTime {
            let tillDate = Date(timeInterval: -lifeTimeInterval, since: Date())
            persistent.deleteAll(till: tillDate)
        }
        persistent.save([message])
    }

}
