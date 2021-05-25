//
//  ProductDetail.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/18.
//

import Foundation

struct Product: Codable {
    let idx: Int
    var categoryIdx: Int
    var category: String
    let title: String
    let contents: String
    let price: String
    let createAt: String
    let isSold: Bool
    let userIdx: Int
    let city: String
    let images: Array<String>
    let likeUsers: Array<Int>
    let name: String
    let location: String
    let profileImage: String?
}

extension Product {
    
    func getIsSold() -> Int {
        return isSold ? 1 : 0
    }
    
    func toString() -> String {
        return "\(idx) \(categoryIdx) \(category) \(title) \(contents) \(price) \(createAt) \(isSold) \(userIdx) \(city) \(images) \(likeUsers) \(name) \(location) \(profileImage ?? "")"
    }
}

extension Array where Element == Product {
    
    func contains(_ array: [Product]) -> Bool {
        return self.map { $0.toString() }.elementsEqual(array.map { $0.toString() })
    }
}
