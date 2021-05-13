//
//  TownLifeCommentData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/13.
//

import Foundation

struct TownLifeCommentData: Codable {
    let idx: Int
    let townLifeIdx: Int
    let comment: String
    let createAt: String
    let userIdx: Int
}
