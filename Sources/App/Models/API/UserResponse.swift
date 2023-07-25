//
//  UserRespnse.swift
//  
//
//  Created by Alaa . on 24/07/2023.
//

import Vapor

struct UserResponse: Content {
  let accessToken: String?
  let user: User.Public

  init(accessToken: Token? = nil, user: User) throws {
    self.accessToken = accessToken?.value
    self.user = user.convertToPublic()
  }
}
