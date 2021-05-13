//
//  ProductRequest.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import Foundation

struct ProductRequest: Codable {
    var categoryIdx: Int
    var title: String
    var contents: String
    var price: String
    var isSold: Int
    var userIdx: Int
    var city: String
    var imageList: Array<String>
}
