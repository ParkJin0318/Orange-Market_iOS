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
    func getAllLikeProduct() -> Single<Array<Product>>
    func getAllMyProduct() -> Single<Array<Product>>
    func getProduct(idx: Int) -> Single<Product>
    func getAllCategory() -> Single<Array<ProductCategory>>
    func updateCategory(idx: Int) -> Single<Void>
    func saveProduct(productRequest: ProductRequest) -> Single<Void>
    func likeProduct(idx: Int) -> Single<Void>
    func updateProduct(idx: Int, productRequest: ProductRequest) -> Single<Void>
    func updateSold(idx: Int) -> Single<Void>
    func deleteProduct(idx: Int) -> Single<Void>
}
