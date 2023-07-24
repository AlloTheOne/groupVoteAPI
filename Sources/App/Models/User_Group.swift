//
//  User_Group.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent
import Vapor

final class User_Group: Model, Content {
    static let schema = "users_groups"
    
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Parent(key: "groupID")
    var group: Group
    
    @Timestamp(key: "joinedAt", on: .create, format: .iso8601)
    var joinedAt: Date?
    
    
    init() { }
    
    init(id: UUID? = nil,
         userID: User.IDValue,
         groupID: Group.IDValue,
         joinedAt: Date? = nil) {
        self.id = id
        self.$user.id = userID
        self.$group.id = groupID
        self.joinedAt = joinedAt
    }
    
}
