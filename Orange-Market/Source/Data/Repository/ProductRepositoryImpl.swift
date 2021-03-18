//
//  ProductRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class ProductRepositoryImpl: ProductRepository {
    
    private lazy var productRemote = ProductRemote()
    private lazy var userRemote = UserRemote()
    
    func getAllProduct(city: String) -> Single<Array<Product>> {
        return productRemote.getAllProduct(city: city).map { productDataList in
            productDataList.map { $0.toModel() }
        }
    }
    
    func getProduct(idx: Int) -> Single<ProductDetail> {
        return productRemote.getProduct(idx: idx).flatMap { productData in
            self.userRemote.getUserInfo(idx: productData.userIdx).map { userData in
                productData.toDetailModel(user: userData)
            }
        }
    }
    
    func saveProduct(productRequest: ProductRequest) -> Single<String> {
        return productRemote.saveProduct(productRequest: productRequest)
    }
}
