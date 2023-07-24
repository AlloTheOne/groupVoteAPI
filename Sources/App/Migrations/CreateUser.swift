//
//  CreateUser.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id() 
            .field("name", .string, .required)
            .field("username", .string, .required)
            .unique(on: "username")
            .field("email", .string, .required)
            .unique(on: "email")
            .field("password", .string, .required)
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
