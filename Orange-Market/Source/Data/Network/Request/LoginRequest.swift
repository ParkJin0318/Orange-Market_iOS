//
//  LoginRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation

struct LoginRequest: Codable {
    let userId: String
    let userPw: String
}
