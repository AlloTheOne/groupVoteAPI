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
    }
    
    // post group + post user_group + post merchant
    func createGroup(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let data = try req.content.decode(Group.self)
        let group = Group(join_id: data.join_id, type: data.type, tie: data.tie, close: data.close, end: data.close, updatedAt: data.updatedAt, createdAt: data.createdAt)
        try await group.save(on: req.db)
        
        let user_group = try User_Group(userID: userID.self, groupID: group.requireID())
        try await user_group.save(on: req.db)
        
//        let merchantDataa = try req.content.decode(createGroupData.self)
//        let merchant = Merchant(userID: userID, groupID: try group.requireID(), name: merchantDataa.name.name, votes: 0, updatedAt: data.updatedAt, createdAt: data.createdAt)
//        try await merchant.save(on: req.db)
        
        return .noContent
    }
    // get group by join id
    
    // update tie - close - end
    
    
    
}


//struct createGroupData: Content {
//    var join_id: Int
//    var tie: Bool
//    var close: Bool
//    var end: Bool
//    var name: merchantData
//}
//
//struct merchantData: Content {
//    var name: String
//}
