//
//  UserInfoRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/12.
//

import Foundation

struct UserInfoRequest: Encodable {
    var name: String? = ""
    var profileImage: String? = ""
}
