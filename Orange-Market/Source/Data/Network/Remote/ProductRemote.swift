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
    
    func saveProduct(productRequest: ProductRequest) -> Single<String> {
        return provider.rx.request(.saveProduct(productRequest: productRequest))
            .map(MessageResponse.self, using: JSONDecoder())
            .map { response in
                return response.message
            }
    }
}
