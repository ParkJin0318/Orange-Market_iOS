//
//  ProductDataSource.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/17.
//

import Foundation
import RxSwift

class ProductDataSource {
    
    private lazy var userRemote = UserRemote()
    private lazy var productRemote = ProductRemote()
    private lazy var categoryCache = ProductCategoryCache()
    
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
    
    
    func getAllLikeProduct() -> Single<Array<Product>> {
        return productRemote.getAllLikeProduct().map {
            $0.map { $0.toModel() }
        }
    }
    
    func getAllMyProduct() -> Single<Array<Product>> {
        return userRemote.getUserProfile()
            .flatMap { profile in
                self.productRemote.getAllProduct(city: profile.city)
                    .map { productDataList in
                        productDataList
                            .map { $0.toModel() }
                            .filter { $0.userIdx == profile.idx }
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
    
    func getAllCategory() -> Single<Array<ProductCategory>> {
        return categoryCache.getAllCategory()
            .map { $0.map { $0.toModel() } }
            .catch { error in
                self.productRemote
                    .getAllCategory()
                    .map { $0.map { $0.toModel() } }
                    .flatMap { categoryList in
                        self.categoryCache
                            .insertCategory(categoryList.map { $0.toEntity() })
                            .flatMap { _ in .just(categoryList)}
                    }
            }
    }
    
    func updateCategory(idx: Int) -> Single<Void> {
        return categoryCache.updateCategory(idx: idx)
    }
    
    func saveProduct(productRequest: ProductRequest) -> Single<Void> {
        return productRemote.saveProduct(productRequest: productRequest)
            .flatMap { _ in
                .just(Void())
            }
    }
    
    func likeProduct(idx: Int) -> Single<Void> {
        return productRemote.likeProduct(idx: idx)
            .flatMap { _ in
                .just(Void())
            }
    }
    
    func updateProduct(idx: Int, productRequest: ProductRequest) -> Single<Void> {
        return productRemote.updateProduct(idx: idx, productRequest: productRequest)
            .flatMap { _ in
                .just(Void())
            }
    }
    
    func updateSold(idx: Int) -> Single<Void> {
        return productRemote.updateSold(idx: idx)
            .flatMap { _ in
                .just(Void())
            }
    }
    
    func deleteProduct(idx: Int) -> Single<Void> {
        return productRemote.deleteProduct(idx: idx)
            .flatMap { _ in
                .just(Void())
            }
    }
}
