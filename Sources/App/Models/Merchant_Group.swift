//
//  File.swift
//  
//
//  Created by Alaa . on 25/07/2023.
//

import Fluent
import Vapor

final class Merchant_Group: Model, Content {
    static let schema = "merchants_groups"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "merchantID")
    var merchant: Merchant
    
    @Parent(key: "groupID")
    var group: Group
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    
    
    init() { }
    
    init(id: UUID? = nil, merchanID: Merchant.IDValue, groupID: Group.IDValue, updatedAt: Date? = nil, createdAt: Date? = nil) {
        self.id = id
        self.$merchant.id = merchanID
        self.$group.id = groupID
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
