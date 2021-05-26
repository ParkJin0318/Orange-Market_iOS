//
//  LocationInfoRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/30.
//

import Foundation

struct LocationInfoRequest: Encodable {
    var city: String? = ""
    var location: String? = ""
}
