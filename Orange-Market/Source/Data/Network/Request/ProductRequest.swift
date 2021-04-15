//
//  ProductRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import Foundation

struct ProductRequest: Codable {
    var topic: String
    var title: String
    var contents: String
    var price: String
    var isSold: Int
    var userIdx: Int
    var city: String
    var imageList: Array<String>
    
    init(topic: String, title: String, contents: String, price: String,
         isSold: Int, userIdx: Int, city: String, imageList: Array<String>) {
        self.topic = topic
        self.title = title
        self.contents = contents
        self.price = price
        self.isSold = isSold
        self.userIdx = userIdx
        self.city = city
        self.imageList = imageList
    }
}
