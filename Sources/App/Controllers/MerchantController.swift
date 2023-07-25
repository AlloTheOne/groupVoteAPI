//
//  MerchantController.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent
import Vapor

struct MerchantController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let merchants = routes.grouped("api", "merchants")
        
        // Auth
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = merchants.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.post(":groupID", use: createMerchant)
    }
    
    // post merchant
    func createMerchant(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userId = try user.requireID()
        print("user id", userId)
        
        let data = try req.content.decode(merchantEData.self)
        print("data", data.name)
        let merchant = Merchant(userID: try data.user.requireID(), name: data.name, votes: data.votes, updatedAt: data.updatedAt, createdAt: data.createdAt)
        try await merchant.save(on: req.db)
        print("data", data.name)
//        let groupID = try req.parameters.require("groupID", as: UUID.self)
//        guard let group = try await Group.find(groupID, on: req.db) else {
//            throw Abort(.notFound, reason: "Gtoup not found")
//        }
//        let merchant_group = try Merchant_Group(merchanID: merchant.requireID(), groupID: group.requireID(), updatedAt: merchant.updatedAt, createdAt: merchant.createdAt)
//        try await merchant_group.save(on: req.db)
        return .noContent
    }
    // update votes
    
    // get merchant
    
    
    
}

//struct User: Content {
//
//}

struct merchantEData: Content {
    var user: User
    var name: String
    var votes: Int
    var updatedAt: Date?
    var createdAt: Date?
}
