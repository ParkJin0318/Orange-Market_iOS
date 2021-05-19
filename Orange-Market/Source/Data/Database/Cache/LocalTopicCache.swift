//
//  LocalTopicCache.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation
import RealmSwift
import RxSwift

class LocalTopicCache {
    lazy var database: Realm! = AppDatabase().getInstance()
    
    func insertTopic(_ categoryList: Array<LocalTopicEntity>) -> Single<Void> {
        return Single.create { [weak self] emitter in
            guard let self = self else {
                emitter(.failure(OrangeError.error(message: "저장 실패")))
                return Disposables.create()
            }
            
            do {
                try self.database.write {
                    let entity = self.database.objects(LocalTopicEntity.self)
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
    
    func getAllTopic() -> Single<Array<LocalTopicEntity>> {
        return Single.create { [weak self] emitter in
            guard let self = self else {
                emitter(.failure(OrangeError.error(message: "조회 실패")))
                return Disposables.create()
            }
            
            let data = self.database.objects(LocalTopicEntity.self)
            
            if (data.isEmpty) {
                emitter(.failure(OrangeError.error(message: "조회 실패")))
            } else {
                emitter(.success(Array(data)))
            }
            return Disposables.create()
        }
    }
    
    func getTopic(idx: Int) -> Single<LocalTopicEntity> {
        return Single.create { [weak self] emitter in
            guard let self = self else {
                emitter(.failure(OrangeError.error(message: "조회 실패")))
                return Disposables.create()
            }
            
            let idxPredicate = NSPredicate(format: "idx = %d", idx)
            
            let data = self.database.objects(LocalTopicEntity.self).filter(idxPredicate).first
            
            if (data == nil) {
                emitter(.failure(OrangeError.error(message: "조회 실패")))
            } else {
                emitter(.success(data!))
            }
            return Disposables.create()
        }
    }
    
    func updateTopic(idx: Int) -> Single<Void> {
        return Single.create { [weak self] emitter in
            guard let self = self else {
                emitter(.failure(OrangeError.error(message: "업데이트 성공")))
                return Disposables.create()
            }
            
            let idxPredicate = NSPredicate(format: "idx = %d", idx)
            
            do {
                if let data = self.database.objects(LocalTopicEntity.self).filter(idxPredicate).first {
                    try self.database.write {
                        data.isSelected = !data.isSelected
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
