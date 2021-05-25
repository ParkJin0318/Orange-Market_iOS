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

extension LocalPost {
    
    func toString() -> String {
        return "\(idx) \(topicIdx) \(topic) \(contents) \(createAt) \(userIdx) \(name) \(location) \(profileImage ?? "") \(city)"
    }
}

extension Array where Element == LocalPost {
    
    func contains(_ array: [LocalPost]) -> Bool {
        return self.map { $0.toString() }.elementsEqual(array.map { $0.toString() })
    }
}
