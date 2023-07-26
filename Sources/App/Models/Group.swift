//
//  Group.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent
import Vapor

final class Group: Model, Content {
    static let schema = "groups"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "join_id")
    var join_id: Int
    
    @OptionalField(key: "type")
    var type: String?
    
    @Field(key: "tie")
    var tie: Bool
    
    @Field(key: "close")
    var close: Bool
    
    @Field(key: "end")
    var end: Bool
    
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var createdAt: Date?
    
    
    init() { }
    
    init(id: UUID? = nil, join_id: Int, type: String?, tie: Bool, close: Bool, end: Bool, updatedAt: Date? = nil, createdAt: Date? = nil) {
        self.id = id
        self.join_id = join_id
        self.type = type
        self.tie = tie
        self.close = close
        self.end = end
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
