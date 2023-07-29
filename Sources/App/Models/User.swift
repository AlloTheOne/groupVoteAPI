//
//  User.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent
import Vapor

final class User: Model, Authenticatable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String

//    @Field(key: "username")
//    var username: String
//
//    @Field(key: "email")
//    var email: String
//
//    @Field(key: "password")
//    var password: String

//    @Children(for: \.$user)
//    var songs: [Song]
//
//    @Siblings(through: Friend.self, from: \.$user, to: \.$friend)
//    public var friends : [User]
//
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)
    var updated_at: Date?
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)
    var created_at: Date?
    
    
    
    init() { }

    init(id: UUID? = nil, name: String, created_at: Date? = nil, updated_at: Date? = nil) {
        self.id = id
        self.name = name
//        self.username = username
//        self.email = email
//        self.password = password
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
//
//extension User: ModelAuthenticatable {
//    static let usernameKey = \User.$username
//    static let passwordHashKey = \User.$password
//
//    func verify(password: String) throws -> Bool {
//        try Bcrypt.verify(password, created: self.password)
//    }
//}

