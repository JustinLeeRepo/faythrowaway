//
//  AuthModel.swift
//  FayThrowaway
//
//  Created by Justin Lee on 7/7/25.
//

import Foundation

struct SignInRequest: Codable {
    let username: String
    let password: String
}

struct SignInResponse: Codable {
    let token: String
}
