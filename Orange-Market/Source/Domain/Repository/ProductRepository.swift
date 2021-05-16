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
    func getProduct(idx: Int) -> Single<ProductDetail>
    func getAllCategory() -> Single<Array<Category>>
    func updateCategory(idx: Int) -> Single<Void>
    func saveProduct(productRequest: ProductRequest) -> Single<String>
    func likeProduct(idx: Int) -> Single<Void>
    func updateProduct(idx: Int, productRequest: ProductRequest) -> Single<String>
    func updateSold(idx: Int) -> Single<Void>
    func deleteProduct(idx: Int) -> Single<Void>
}
