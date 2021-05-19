//
//  ProductData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation

struct ProductData: Codable {
    let idx: Int
    let categoryIdx: Int
    let title: String
    let contents: String
    let price: String
    let createAt: String
    let isSold: Bool
    let userIdx: Int
    let city: String
    let images: Array<String>
    let likeUsers: Array<Int>
}

extension ProductData {
    
    func toModel() -> Product {
        return Product(
            idx: self.idx,
            categoryIdx: self.categoryIdx,
            title: self.title,
            price: self.price,
            createAt: self.createAt,
            isSold: self.isSold,
            userIdx: self.userIdx,
            city: self.city,
            image: self.images.first ?? "",
            like: self.likeUsers.count
        )
    }
    
    func toDetailModel(user: UserData, category: ProductCategoryEntity) -> ProductDetail {
        return ProductDetail(
            idx: self.idx,
            categoryIdx: self.categoryIdx,
            category: category.name ?? "",
            title: self.title,
            contents: self.contents,
            price: self.price,
            createAt: self.createAt,
            isSold: self.isSold,
            userIdx: self.userIdx,
            city: self.city,
            images: self.images,
            likeUsers: self.likeUsers,
            name: user.name,
            location: user.location,
            profileImage: user.profileImage
        )
    }
}
