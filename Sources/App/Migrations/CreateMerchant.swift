//
//  CreateMerchant.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent

struct CreateMerchant: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Merchant.schema)
            .id()
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("name", .string, .required)
            .field("votes", .int, .required, .sql(.default(0)))
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Merchant.schema).delete()
    }
}
