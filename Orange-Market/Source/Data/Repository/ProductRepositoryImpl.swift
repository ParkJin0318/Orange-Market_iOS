//
//  ProductRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class ProductRepositoryImpl: ProductRepository {
    
    private lazy var userRemote = UserRemote()
    private lazy var productRemote = ProductRemote()
    private lazy var categoryCache = CategoryCache()
    
    func getAllProduct() -> Single<Array<Product>> {
        return userRemote.getUserProfile()
            .flatMap { profile in
                Single.zip(
                    self.productRemote.getAllProduct(city: profile.city),
                    self.getAllCategory()
                ) { productDataList, categoryList in
                    
                    let selectCategotyList = categoryList
                        .filter { $0.isSelected }
                        .map { $0.idx }
                    
                    return productDataList
                        .filter { selectCategotyList.contains($0.categoryIdx) }
                        .map { $0.toModel() }
                }
            }
    }
    
    func getProduct(idx: Int) -> Single<ProductDetail> {
        return productRemote.getProduct(idx: idx)
            .flatMap { productData in
                Single.zip(
                    self.userRemote.getUserInfo(idx: productData.userIdx),
                    self.categoryCache.getCategory(idx: productData.categoryIdx)
                ) { userData, categoryEntity in
                    return productData.toDetailModel(user: userData, category: categoryEntity)
                }
            }
    }
    
    func getAllCategory() -> Single<Array<Category>> {
        return categoryCache.getAllCategory()
            .map { $0.map { $0.toModel() } }
            .catch { error in
                self.productRemote
                    .getAllCategory()
                    .map { $0.map { $0.toModel() } }
                    .flatMap {
                        self.categoryCache
                            .insertCategory($0.map { $0.toEntity() })
                            .andThen(Single.just($0))
                    }
            }
    }
    
    func updateCategory(idx: Int) -> Completable {
        return categoryCache.updateCategory(idx: idx)
    }
    
    func saveProduct(productRequest: ProductRequest) -> Single<String> {
        return productRemote.saveProduct(productRequest: productRequest)
    }
    
    func updateProduct(idx: Int, productRequest: ProductRequest) -> Single<String> {
        return productRemote.updateProduct(idx: idx, productRequest: productRequest)
    }
    
    func updateSold(idx: Int) -> Single<String> {
        return productRemote.updateSold(idx: idx)
    }
    
    func deleteProduct(idx: Int) -> Single<String> {
        return productRemote.deleteProduct(idx: idx)
    }
}
