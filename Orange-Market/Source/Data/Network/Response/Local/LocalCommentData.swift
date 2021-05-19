//
//  LocalCommentData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/13.
//

import Foundation

struct LocalCommentData: Codable {
    let idx: Int
    let postIdx: Int
    let comment: String
    let createAt: String
    let userIdx: Int
}
