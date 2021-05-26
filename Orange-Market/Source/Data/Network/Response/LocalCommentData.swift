//
//  LocalCommentData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/25.
//

import Foundation

struct LocalCommentData: Codable {
    let idx: Int
    let postIdx: Int
    let comment: String
    let createAt: String
    let userIdx: Int
    let name: String
    let location: String
    let profileImage: String?
}

extension LocalCommentData {
    
    func toModel(isMyComment: Bool) -> LocalComment {
        return LocalComment(
            idx: self.idx,
            postIdx: self.postIdx,
            comment: self.comment,
            createAt: self.createAt,
            userIdx: self.userIdx,
            name: self.name,
            location: self.location,
            profileImage: self.profileImage,
            isMyComment: isMyComment
        )
    }
}
