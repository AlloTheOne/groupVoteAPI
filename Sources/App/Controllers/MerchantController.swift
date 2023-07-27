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
        
        tokenAuthGroup.post("m", use: createGroupMerchant)
        tokenAuthGroup.post(":groupID", use: createMerchant)
        tokenAuthGroup.get(":groupID",use: getAllMerchant)
    }
    
    // post merchant -- i want to create group first then merchant?
    func createGroupMerchant(_ req: Request) async throws -> HTTPStatus {
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
    // create merchant only .. should i let user join group here?
    func createMerchant(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userId = try user.requireID()

        let data = try req.content.decode(CreateMerchantEData.self)

        let merchant = Merchant(userID: userId.self, name: data.name, votes: 0)
        try await merchant.save(on: req.db)

        let groupID = try req.parameters.require("groupID", as: UUID.self)

        guard let group = try await Group.find(groupID, on: req.db) else {
            throw Abort(.notFound, reason: "Gtoup not found")
        }
        let merchant_group = try Merchant_Group(merchanID: merchant.requireID(), groupID: group.requireID())
        try await merchant_group.save(on: req.db)
        return .noContent
    }
    
    // update votes
    
    // get all merchants in a group - merchant, merchant_group, group -- it works!
    func getAllMerchant(_ req: Request) async throws -> [Merchant] {
        let user = try req.auth.require(User.self)
        let userId = try user.requireID()
//        let groupJoinId = req.query[Int.self, at: "join_id"]
        let groupID = try req.parameters.require("groupID", as: UUID.self)
//        let merIDs = try await Merchant_Group.query(on: req.db)
//            .join(Group.self, on: \Group.$id == \Merchant_Group.$group.$id)
//            .filter(Group.self, \.$id == groupID)
//            .all()
        return try await Merchant.query(on: req.db)
            .join(Merchant_Group.self, on: \Merchant_Group.$merchant.$id == \Merchant.$id)
            .join(Group.self, on: \Group.$id == \Merchant_Group.$group.$id)
            .filter(Group.self, \.$id == groupID)
//            .filter(Merchant.self, \.$id == merIDs)
            .all()
    }
    
    // get merchant by it's id
    
    // get highest score merchant 
    
    
    
    
    
}

//struct User: Content {
//
//}

struct CreateMerchantEData: Content {
    var name: String
}
