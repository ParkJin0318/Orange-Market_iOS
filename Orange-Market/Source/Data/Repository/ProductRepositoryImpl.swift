//
//  ProductRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class ProductRepositoryImpl: ProductRepository {
    
    private lazy var authRemote = AuthRemote()
    private lazy var userRemote = UserRemote()
    private lazy var productRemote = ProductRemote()
    
    func getAllProduct() -> Single<Array<Product>> {
        return authRemote.getUserProfile().flatMap { profile in
            self.productRemote.getAllProduct(city: profile.city).map { productDataList in
                productDataList.map { $0.toModel() }
            }
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
