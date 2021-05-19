//
//  LocalPostRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/13.
//

import Foundation

struct LocalPostRequest: Encodable {
    let topic: String
    let contents: String
    let userIdx: Int
    let city: String
}
