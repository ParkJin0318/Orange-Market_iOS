//
//  LocalPostData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/13.
//

import Foundation

struct LocalPostData: Codable {
    let idx: Int
    let topic: String
    let contents: String
    let createAt: String
    let userIdx: Int
    let city: String
}
