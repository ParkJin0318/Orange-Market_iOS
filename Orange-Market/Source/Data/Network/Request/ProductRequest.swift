//
//  ProductRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import Foundation

struct ProductRequest: Codable {
    var title: String
    var contents: String
    var price: String
    var isSold: Int
    var userId: String
    var city: String
    var location: String
    var imageList: Array<String>
    
    init(title: String, contents: String, price: String, isSold: Int,
         userId: String, city: String, location: String, imageList: Array<String>) {
        self.title = title
        self.contents = contents
        self.price = price
        self.isSold = isSold
        self.userId = userId
        self.city = city
        self.location = location
        self.imageList = imageList
    }
}
