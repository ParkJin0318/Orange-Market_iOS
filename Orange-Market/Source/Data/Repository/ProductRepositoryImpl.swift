//
//  ProductRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class ProductRepositoryImpl: ProductRepository {
    
    private lazy var dataSource = ProductDataSource()
    
    func getAllProduct() -> Single<Array<Product>> {
        return dataSource.getAllProduct()
    }
    
    func getAllLikeProduct() -> Single<Array<Product>> {
        return dataSource.getAllLikeProduct()
    }
    
    func getAllMyProduct() -> Single<Array<Product>> {
        return dataSource.getAllMyProduct()
    }
    
    func getProduct(idx: Int) -> Single<ProductDetail> {
        return dataSource.getProduct(idx: idx)
    }
    
    func getAllCategory() -> Single<Array<ProductCategory>> {
        return dataSource.getAllCategory()
    }
    
    func updateCategory(idx: Int) -> Single<Void> {
        return dataSource.updateSold(idx: idx)
    }
    
    func saveProduct(productRequest: ProductRequest) -> Single<Void> {
        return dataSource.saveProduct(productRequest: productRequest)
    }
    
    func likeProduct(idx: Int) -> Single<Void> {
        return dataSource.likeProduct(idx: idx)
    }
    
    func updateProduct(idx: Int, productRequest: ProductRequest) -> Single<Void> {
        return dataSource.updateProduct(idx: idx, productRequest: productRequest)
    }
    
    func updateSold(idx: Int) -> Single<Void> {
        return dataSource.updateSold(idx: idx)
    }
    
    func deleteProduct(idx: Int) -> Single<Void> {
        return dataSource.deleteProduct(idx: idx)
    }
}
