//
//  ProductData.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation

struct ProductData: Codable {
    let title: String
    let contents: String
    let price: String
    let createAt: Date?
    let userId: String
    let city: String
    let location: String
    let imageList: Array<String>
}
