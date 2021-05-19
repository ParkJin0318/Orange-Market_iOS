//
//  LocalComment.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation

struct LocalComment: Codable {
    let idx: Int
    let postIdx: Int
    let comment: String
    let createAt: String
    let userIdx: Int
    let name: String
    let location: String
    let profileImage: String?
}
