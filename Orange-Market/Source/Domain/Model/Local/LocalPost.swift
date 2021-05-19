//
//  LocalPost.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation

struct LocalPost: Codable {
    let idx: Int
    let topicIdx: Int
    let topic: String
    let contents: String
    let createAt: String
    let userIdx: Int
    let name: String
    let location: String
    let profileImage: String?
    let city: String
}
