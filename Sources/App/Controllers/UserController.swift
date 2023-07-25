//
//  UserController.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Foundation
import Vapor
import FluentKit

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        usersRoutes.post(use: createHandler)
        
        let basicAuthMiddleware = User.authenticator()
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        // login
        basicAuthGroup.post("login", use: loginHandler)
        // get all users -- Might remove this
        usersRoutes.get( use: getAllUsernamesHandler)
        
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = usersRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        tokenAuthGroup.get("me", use: getHandler)
      
    }
    // sign up -- POST USER
    func createHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }
    
    // log in -- create token
    func loginHandler(_ req: Request) throws -> EventLoopFuture<Token> {
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req.db).map { token }
    }
    // might remove this
    func getAllUsernamesHandler(_ req: Request) throws -> EventLoopFuture<[String]> {
        return User.query(on: req.db).all().map { users in
            users.map { $0.username }
        }
    }
    
    // update name -- maybe later
    
    // delete account -- maybe later
    
    // get public info -- ME
    func getHandler(_ req: Request) throws -> UserResponse {
        let user = try req.auth.require(User.self)
        return try .init(user: user)
    }
    
    // change password 
    
    
    
    
    
    

}
