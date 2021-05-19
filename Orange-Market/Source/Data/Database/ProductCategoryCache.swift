//
//  ProductCategoryCache.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/27.
//

import Foundation
import RealmSwift
import RxSwift

class ProductCategoryCache {
    lazy var database: Realm! = AppDatabase().getInstance()
    
    func insertCategory(_ categoryList: Array<ProductCategoryEntity>) -> Single<Void> {
        return Single.create { [weak self] emitter in
            guard let self = self else {
                emitter(.failure(OrangeError.error(message: "저장 실패")))
                return Disposables.create()
            }
            
            do {
                try self.database.write {
                    let entity = self.database.objects(ProductCategoryEntity.self)
                    self.database.delete(entity)
                    
                    self.database.add(categoryList)
                }
                emitter(.success(Void()))
            }
            catch {
                emitter(.failure(OrangeError.error(message: "저장 실패")))
            }
            return Disposables.create()
        }
    }
    
    func getAllCategory() -> Single<Array<ProductCategoryEntity>> {
        return Single.create { [weak self] emitter in
            guard let self = self else {
                emitter(.failure(OrangeError.error(message: "조회 실패")))
                return Disposables.create()
            }
            
            let data = self.database.objects(ProductCategoryEntity.self)
            
            if (data.isEmpty) {
                emitter(.failure(OrangeError.error(message: "조회 실패")))
            } else {
                emitter(.success(Array(data)))
            }
            return Disposables.create()
        }
    }
    
    func getCategory(idx: Int) -> Single<ProductCategoryEntity> {
        return Single.create { [weak self] emitter in
            guard let self = self else {
                emitter(.failure(OrangeError.error(message: "조회 실패")))
                return Disposables.create()
            }
            
            let idxPredicate = NSPredicate(format: "idx = %d", idx)
            
            let data = self.database.objects(ProductCategoryEntity.self).filter(idxPredicate).first
            
            if (data == nil) {
                emitter(.failure(OrangeError.error(message: "조회 실패")))
            } else {
                emitter(.success(data!))
            }
            return Disposables.create()
        }
    }
    
    func updateCategory(idx: Int) -> Single<Void> {
        return Single.create { [weak self] emitter in
            guard let self = self else {
                emitter(.failure(OrangeError.error(message: "업데이트 성공")))
                return Disposables.create()
            }
            
            let idxPredicate = NSPredicate(format: "idx = %d", idx)
            
            do {
                if let category = self.database.objects(ProductCategoryEntity.self).filter(idxPredicate).first {
                    try self.database.write {
                        category.isSelected = !category.isSelected
                    }
                }
                emitter(.success(Void()))
            }
            catch {
                emitter(.failure(OrangeError.error(message: "업데이트 실패")))
            }
            
            return Disposables.create()
        }
    }
}
