//
//  Response.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation

struct Response<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T
}
