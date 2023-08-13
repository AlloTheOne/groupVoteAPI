//
//  Token.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent
import Vapor

final class Token: Model, Content, Decodable {
    static let schema = "tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "userID")
    var user: User

    @Timestamp(key: "created_at", on: .create, format: .iso8601)
    var created_at: Date?
    
    init() { }

    init(id: UUID? = nil, value: String, userID: User.IDValue, created_at: Date? = nil) {
        self.id = id
        self.value = value
        $user.id = userID
        self.created_at = created_at
    }
}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = [UInt8].random(count: 16).base64
        return try Token(value: random, userID: user.requireID())
    }
}

extension Token: ModelTokenAuthenticatable {
    
    typealias User = App.User

    static let valueKey = \Token.$value
    static let userKey = \Token.$user

    var isValid: Bool {
        true
    }
}
