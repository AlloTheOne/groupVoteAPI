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
        
        tokenAuthGroup.post("m", use: createMerchant)
    }
    
    // post merchant -- i want to create group first then merchant?
    func createMerchant(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userId = try user.requireID()
//        print("user id", userId)
        // create group + join
        // get group
        // create merchant
        let createGroup = try await GroupController().createGroup(req)
        let data = try req.content.decode(CreateMerchantEData.self)

        print("data", data.name)
        let merchant = Merchant(userID: userId.self, name: data.name, votes: 0)
        try await merchant.save(on: req.db)
//        print("data", data.name)
//        let groupID = try req.parameters.require("groupID", as: UUID.self)
        let newGroupID = createGroup.id
        guard let group = try await Group.find(newGroupID, on: req.db) else {
            throw Abort(.notFound, reason: "Gtoup not found")
        }
        let merchant_group = try Merchant_Group(merchanID: merchant.requireID(), groupID: group.requireID())
        try await merchant_group.save(on: req.db)
        return .noContent
    }
    // update votes
    
    // get merchant
    
    
    
}

//struct User: Content {
//
//}

struct CreateMerchantEData: Content {
    var name: String
}
