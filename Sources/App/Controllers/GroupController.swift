//
//  GroupController.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Fluent
import Vapor


struct GroupController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let groups = routes.grouped("api", "groups")
        
        // Auth
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = groups.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.post("create", use: createGroup)
        tokenAuthGroup.post(":join_id", use: joinGroup)
        tokenAuthGroup.patch(use: updateGroup)
    }
    
    // post group + post user_group + post merchant
    func createGroup(_ req: Request) async throws -> Group {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        // first generate second check db third either store or regenerate :)
        var join_id = random(digits: 8)
        guard let IntJoin = Int(join_id) else { throw Abort(.notFound, reason: "group not found")  }

        if try await getGroupByJoinIDIN(req, join_id: IntJoin) == true {
            join_id = random(digits: 8)
        }
            let group = Group(join_id: IntJoin,
                              type: "vote",
                              tie: false,
                              close: false,
                              end: false)
            try await group.save(on: req.db)
            
            let user_group = try User_Group(userID: userID.self, groupID: group.requireID())
            try await user_group.save(on: req.db)
            
            return group
        
    }
    // get group by join id
    func joinGroup(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let group = try await getGroupByJoinID(req)
        
        let user_group = try User_Group(userID: userID.self, groupID: group.requireID())
        try await user_group.save(on: req.db)
        return .noContent
    }
    
    // query to get the group
    func getGroupByJoinID(_ req: Request) async throws -> Group {
        
        let joinID = try req.parameters.require("join_id", as: Int.self)
        
        guard let group = try await Group.query(on: req.db)
            .filter(\.$join_id == joinID)
            .all().last else {
            throw Abort(.notFound, reason: "group not found")
        }
        return group
    }
    
    // query to get the group
    func getGroupByJoinIDIN(_ req: Request, join_id: Int) async throws -> Bool {
        
        
        guard let group = try await Group.query(on: req.db)
            .filter(\.$join_id == join_id)
            .all().last else {
            return false
        }
        return true
    }
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    // join group using returned groupID value from join id
    // update tie - close - end
    func updateGroup(_ req: Request) async throws -> HTTPStatus {
        try req.auth.require(User.self)
        let group = try req.content.decode(updateGroupData.self)
        
        guard let storedGroup = try await Group.find(group.groupID, on: req.db) else {
            throw Abort(.notFound, reason: "group not found")
        }
        
        if let tie = group.tie {
            storedGroup.tie = tie
        }
        
        if let close = group.close {
            storedGroup.close = close
        }
            
        if let end = group.end {
            storedGroup.end = end
        }
        try await storedGroup.update(on: req.db)
        return .noContent
    }
    
    
}


struct updateGroupData: Content {
    var groupID: UUID
    var tie: Bool?
    var close: Bool?
    var end: Bool?

}
