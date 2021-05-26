//
//  ProductRemote.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift
import Moya

class ProductRemote {
    private lazy var provider: MoyaProvider<ProductAPI> = MoyaProvider()
    
    func getAllProduct(city: String) -> Single<Array<Product>> {
        return provider.rx.request(.getAllProduct(city: city))
            .map(Response<Array<Product>>.self, using: JSONDecoder())
            .map { response -> Array<Product> in
                return response.data
            }
    }
    
    func getAllLikeProduct() -> Single<Array<Product>> {
        return provider.rx.request(.getAllLikeProduct)
            .map(Response<Array<Product>>.self, using: JSONDecoder())
            .map { response -> Array<Product> in
                return response.data
            }
    }
    
    func getProduct(idx: Int) -> Single<Product> {
        return provider.rx.request(.getProduct(idx: idx))
            .map(Response<Product>.self, using: JSONDecoder())
            .map { response -> Product in
                return response.data
            }
    }
    
    func getAllCategory() -> Single<Array<ProductCategoryData>> {
        return provider.rx.request(.getAllCategory)
            .map(Response<Array<ProductCategoryData>>.self, using: JSONDecoder())
            .map { response -> Array<ProductCategoryData> in
                return response.data
            }
    }
    
    func saveProduct(productRequest: ProductRequest) -> Single<Void> {
        return provider.rx.request(.saveProduct(productRequest: productRequest))
            .map { response -> Void in
                return Void()
            }
    }
    
    func likeProduct(idx: Int) -> Single<Void> {
        return provider.rx.request(.likeProduct(idx: idx))
            .map { response -> Void in
                return Void()
            }
    }
    
    func updateProduct(idx: Int, productRequest: ProductRequest) -> Single<Void> {
        return provider.rx.request(.updateProduct(idx: idx, productRequest: productRequest))
            .map { response -> Void in
                return Void()
            }
    }
    
    func updateSold(idx: Int) -> Single<Void> {
        return provider.rx.request(.updateSold(idx: idx))
            .map { response -> Void in
                return Void()
            }
    }
    
    func deleteProduct(idx: Int) -> Single<Void> {
        return provider.rx.request(.deleteProduct(idx: idx))
            .map { response -> Void in
                return Void()
            }
    }
}
