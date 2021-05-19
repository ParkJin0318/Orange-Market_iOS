//
//  LocalCommentRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation

struct LocalCommentRequest: Encodable {
    let postIdx: Int
    let comment: String
    let location: String
    let userIdx: Int
}

