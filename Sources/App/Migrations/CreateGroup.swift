//
//  CreateGroup.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent

struct CreateGroup: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Group.schema)
            .id()
            .field("join_id", .int, .required)
            .field("type", .string, .sql(.default("vote")))
            .field("tie", .bool, .required, .sql(.default(false)))
            .field("close", .bool, .required, .sql(.default(false)))
            .field("end", .bool, .required, .sql(.default(false)))
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Group.schema).delete()
    }
}
