//
//  RegisterRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation

struct RegisterRequest: Codable {
    let userId: String
    let userPw: String
    let name: String
    let city: String
    let location: String
    let profileImage: String
    
    init(userId: String, userPw: String, name: String, city: String, location: String, profileImage: String) {
        self.userId = userId
        self.userPw = userPw
        self.name = name
        self.city = city
        self.location = location
        self.profileImage = profileImage
    }
}
