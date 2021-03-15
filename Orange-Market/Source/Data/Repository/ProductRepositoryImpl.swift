//
//  ProductRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class ProductRepositoryImpl: ProductRepository {
    
    private lazy var remote = ProductRemote()
    
    func getAllProduct(city: String) -> Single<Array<ProductData>> {
        return remote.getAllProduct(city: city)
    }
}
