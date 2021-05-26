//
//  LoginRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

struct LoginRequest: Codable {
    var userId: String
    var userPw: String
}
