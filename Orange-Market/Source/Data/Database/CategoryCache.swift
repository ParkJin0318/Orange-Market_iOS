//
//  CategoryCache.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/27.
//

import Foundation
import RealmSwift
import RxSwift

class CategoryCache {
    lazy var database: Realm! = AppDatabase().getInstance()
    
    func insertCategory(_ categoryList: [CategoryEntity]) -> Completable {
        return Completable.create { [weak self] emitter in
            guard let self = self else {
                emitter(.error(OrangeError.error(message: "저장 실패")))
                return Disposables.create()
            }
            do {
                try self.database.write {
                    let entity = self.database.objects(CategoryEntity.self)
                    self.database.delete(entity)
                    
                    self.database.add(categoryList)
                }
                emitter(.completed)
            }
            catch {
                emitter(.error(OrangeError.error(message: "저장 실패")))
            }
            return Disposables.create()
        }
    }
    
}
