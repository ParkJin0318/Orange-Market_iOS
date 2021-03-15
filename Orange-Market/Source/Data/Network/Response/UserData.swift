//
//  UserData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation

struct UserData: Codable {
    let idx: Int
    let userId: String
    let userPw: String
    let name: String
    let city: String
    let location: String
    let profileImage: String?
}
