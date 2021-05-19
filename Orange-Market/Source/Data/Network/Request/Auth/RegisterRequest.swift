//
//  RegisterRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation

struct RegisterRequest: Encodable {
    var userId: String? = ""
    var userPw: String? = ""
    var name: String? = ""
    var city: String? = ""
    var location: String? = ""
    var profileImage: String? = ""
}
