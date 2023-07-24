//
//  Merchant.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent
import Vapor

final class Merchant: Model, Content {
    static let schema = "merchants"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Parent(key: "groupID")
    var group: Group
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "Votes")
    var votes: Int
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    
    
    init() { }
    
    init(id: UUID? = nil, userID: User.IDValue, groupID: Group.IDValue, name: String, votes: Int, updatedAt: Date?, createdAt: Date?) {
        self.id = id
        self.$user.id = userID
        self.$group.id = groupID
        self.name = name
        self.votes = votes
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
