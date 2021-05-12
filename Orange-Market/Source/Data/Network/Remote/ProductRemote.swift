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
    
    func getAllProduct(city: String) -> Single<Array<ProductData>> {
        return provider.rx.request(.getAllProduct(city: city))
            .map(Response<Array<ProductData>>.self, using: JSONDecoder())
            .map { response -> Array<ProductData> in
                return response.data
            }
    }
    
    func getAllLikeProduct() -> Single<Array<ProductData>> {
        return provider.rx.request(.getAllLikeProduct)
            .map(Response<Array<ProductData>>.self, using: JSONDecoder())
            .map { response -> Array<ProductData> in
                return response.data
            }
    }
    
    func getProduct(idx: Int) -> Single<ProductData> {
        return provider.rx.request(.getProduct(idx: idx))
            .map(Response<ProductData>.self, using: JSONDecoder())
            .map { response -> ProductData in
                return response.data
            }
    }
    
    func getAllCategory() -> Single<Array<CategoryData>> {
        return provider.rx.request(.getAllCategory)
            .map(Response<Array<CategoryData>>.self, using: JSONDecoder())
            .map { response -> Array<CategoryData> in
                return response.data
            }
    }
    
    func saveProduct(productRequest: ProductRequest) -> Single<String> {
        return provider.rx.request(.saveProduct(productRequest: productRequest))
            .map(MessageResponse.self, using: JSONDecoder())
            .map { response in
                return response.message
            }
    }
    
    func likeProduct(idx: Int) -> Single<String> {
        return provider.rx.request(.likeProduct(idx: idx))
            .map(MessageResponse.self, using: JSONDecoder())
            .map { response in
                return response.message
            }
    }
    
    func updateProduct(idx: Int, productRequest: ProductRequest) -> Single<String> {
        return provider.rx.request(.updateProduct(idx: idx, productRequest: productRequest))
            .map(MessageResponse.self, using: JSONDecoder())
            .map { response in
                return response.message
            }
    }
    
    func updateSold(idx: Int) -> Single<String> {
        return provider.rx.request(.updateSold(idx: idx))
            .map(MessageResponse.self, using: JSONDecoder())
            .map { response in
                return response.message
            }
    }
    
    func deleteProduct(idx: Int) -> Single<String> {
        return provider.rx.request(.deleteProduct(idx: idx))
            .map(MessageResponse.self, using: JSONDecoder())
            .map { response in
                return response.message
            }
    }
}
