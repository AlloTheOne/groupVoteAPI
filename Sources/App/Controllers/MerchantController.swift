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
        
        tokenAuthGroup.post(use: createGroupMerchant)
        tokenAuthGroup.post(":groupID", use: createMerchant)
        tokenAuthGroup.get(":groupID",use: getAllMerchant)
        tokenAuthGroup.get("winner",":groupID", use: getHighestScore)
        tokenAuthGroup.patch(use: updateVotes)
    }
    
    // post merchant -- i want to create group first then merchant?
    func createGroupMerchant(_ req: Request) async throws -> Merchant_Group {
        let user = try req.auth.require(User.self)
        let userId = try user.requireID()
        // create group + join
        // get group
        // create merchant
        let createGroup = try await GroupController().createGroup(req)
        let data = try req.content.decode(CreateMerchantEData.self)

//        print("data", data.name)
        let merchant = Merchant(userID: userId.self, name: data.name, votes: 0)
        try await merchant.save(on: req.db)
        let newGroupID = createGroup.id
        guard let group = try await Group.find(newGroupID, on: req.db) else {
            throw Abort(.notFound, reason: "Gtoup not found")
        }
        let merchant_group = try Merchant_Group(merchanID: merchant.requireID(), groupID: group.requireID())
        try await merchant_group.save(on: req.db)
        return merchant_group
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
    
    
    
    // get all merchants in a group - merchant, merchant_group, group -- it works!
    func getAllMerchant(_ req: Request) async throws -> [Merchant] {
        try req.auth.require(User.self)
        
        let groupID = try req.parameters.require("groupID", as: UUID.self)

        return try await Merchant.query(on: req.db)
            .join(Merchant_Group.self, on: \Merchant_Group.$merchant.$id == \Merchant.$id)
            .join(Group.self, on: \Group.$id == \Merchant_Group.$group.$id)
            .filter(Group.self, \.$id == groupID)

            .all()
    }
    
    // get merchant by it's id - why?
    
    // get highest score merchant
    func getHighestScore(_ req: Request) async throws -> Merchant {
        try req.auth.require(User.self)
        let groupID = try req.parameters.require("groupID", as: UUID.self)
        
        return try await Merchant.query(on: req.db)
            .join(Merchant_Group.self, on: \Merchant_Group.$merchant.$id == \Merchant.$id)
            .join(Group.self, on: \Group.$id == \Merchant_Group.$group.$id)
            .filter(Group.self, \.$id == groupID)
            .sort(\.$votes)
            .all().last!
    }
    
    // update votes
    func updateVotes(_ req: Request) async throws -> HTTPStatus {

        
        let newVote = try req.content.decode(updateVotesData.self)
        
        guard let storedMerchant = try await Merchant.find(newVote.id, on: req.db) else {
            throw Abort(.notFound, reason: "merchant not found")
        }
        storedMerchant.votes = newVote.votes
        try await storedMerchant.update(on: req.db)
        
        return .noContent
    }
    
}


struct CreateMerchantEData: Content {
    var name: String
}

struct updateVotesData: Content {
    var id: UUID
    var votes: Int
}
