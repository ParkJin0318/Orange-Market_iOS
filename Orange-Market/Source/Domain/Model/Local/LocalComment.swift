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

extension LocalComment {
    
    func toString() -> String {
        return "\(idx) \(postIdx) \(comment) \(createAt) \(userIdx) \(name) \(location) \(profileImage ?? "")"
    }
}

extension Array where Element == LocalComment {
    
    func contains(_ array: [LocalComment]) -> Bool {
        return self.map { $0.toString() }.elementsEqual(array.map { $0.toString() })
    }
}
