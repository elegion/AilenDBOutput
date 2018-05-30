//
//  PersistentStoragingProtocol.swift
//  AilenDBOutput
//
//  Created by Arkady Smirnov on 5/23/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import Foundation
import Ailen

public protocol PersistentStoragingProtocol {
    func save(token: String, payload: Codable)
    func deleteAll(till date: Date)
}
