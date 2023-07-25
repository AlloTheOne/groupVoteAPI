//
//  CreateMerchant_Group.swift
//  
//
//  Created by Alaa . on 25/07/2023.
//

import Fluent

struct CreateMerchant_Group: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Merchant_Group.schema)
            .id()
            .field("merchantID", .uuid, .required, .references("merchants", "id"))
            .field("groupID", .uuid, .required, .references("groups", "id"))
            .field("updatedAt", .string)
            .field("createdAt", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Merchant_Group.schema).delete()
    }
}
