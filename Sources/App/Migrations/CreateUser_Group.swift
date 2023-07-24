//
//  CreateUser_Group.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent

struct CreateUser_Group: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User_Group.schema)
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("groupID", .uuid, .required, .references("groups", "id"))
            .field("joinedAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User_Group.schema).delete()
    }
}
