//
//  CreateToken.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent

struct CreateToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Token.schema)
            .id()
            .field("value", .string, .required)
            .unique(on: "value")
            .field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("created_at", .string)
            .create()
        
    }

    func revert(on database: Database) async throws {
        try await database.schema(Token.schema).delete()
    }
}
