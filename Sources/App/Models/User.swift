//
//  User.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent
import Vapor

final class User: Model, Authenticatable, Decodable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String

    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updated_at: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var created_at: Date?
    
    
    
    init() { }

    init(id: UUID? = nil, name: String, created_at: Date? = nil, updated_at: Date? = nil) {
        self.id = id
        self.name = name
        self.created_at = created_at
        self.updated_at = updated_at
    }

    struct Public: Content {
        var id: UUID?
        var name: String
    }
}

extension User: Content { }

extension User {
    func convertToPublic() -> User.Public {
        User.Public(id: id, name: name)
    }
}

