//
//  ProductDetail.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/18.
//

import Foundation

struct ProductDetail {
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
    let imageList: Array<String>
    let name: String
    let location: String
    let profileImage: String?
    
    init() {
        self.idx = 0
        self.categoryIdx = 0
        self.category = ""
        self.title = ""
        self.contents = ""
        self.price = ""
        self.createAt = ""
        self.isSold = false
        self.userIdx = 0
        self.city = ""
        self.imageList = []
        self.name = ""
        self.location = ""
        self.profileImage = ""
    }
    
    init(
        idx: Int,
        categoryIdx: Int,
        category: String,
        title: String,
        contents: String,
        price: String,
        createAt: String,
        isSold: Bool,
        userIdx: Int,
        city: String,
        imageList: Array<String>,
        name: String,
        location: String,
        profileImage: String?
    ) {
        self.idx = idx
        self.categoryIdx = categoryIdx
        self.category = category
        self.title = title
        self.contents = contents
        self.price = price
        self.createAt = createAt
        self.isSold = isSold
        self.userIdx = userIdx
        self.city = city
        self.imageList = imageList
        self.name = name
        self.location = location
        self.profileImage = profileImage
    }
}

extension ProductDetail {
    
    func getIsSold() -> Int {
        return isSold ? 1 : 0
    }
}
