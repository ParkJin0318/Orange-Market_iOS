//
//  ProductRepository.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

protocol ProductRepository {
    func getAllProduct() -> Single<Array<Product>>
    func getProduct(idx: Int) -> Single<ProductDetail>
    func saveProduct(productRequest: ProductRequest) -> Single<String>
    func updateProduct(idx: Int, productRequest: ProductRequest) -> Single<String>
    func deleteProduct(idx: Int) -> Single<String>
}
