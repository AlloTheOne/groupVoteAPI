//
//  UserController.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Foundation
import Vapor
import FluentKit
// change to async await + remove password, username, email keep the name
struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        usersRoutes.post(use: createHandler)

        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = usersRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        tokenAuthGroup.get("me", use: getHandler)
        tokenAuthGroup.patch(use: updateName)
      
    }
    // sign up -- POST USER
    func createHandler(_ req: Request) async throws -> Token {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        let token = try Token.generate(for: user)
        try await token.save(on: req.db)
        return token
    }
    

    // update name -- maybe later
    func updateName(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userId = try user.requireID()
        let newName = try req.content.decode(updateNameData.self)
        
        guard let storedUser = try await User.find(userId, on: req.db)
        else {
            throw Abort(.notFound, reason: "user not found")
        }
        storedUser.name = newName.name
        try await storedUser.update(on: req.db)
        return .noContent
    }
    // get public info -- ME
    func getHandler(_ req: Request) throws -> UserResponse {
        let user = try req.auth.require(User.self)
        return try .init(user: user)
    }
    
  
}

struct updateNameData: Content {
    var name: String
}
