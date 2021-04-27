//
//  AppDatabase.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/27.
//

import RealmSwift

class AppDatabase {
    private static var INSTANCE: Realm!
    
    func getInstance() -> Realm! {
        if (AppDatabase.INSTANCE == nil) {
            AppDatabase.INSTANCE = try! Realm()
        }
        return AppDatabase.INSTANCE
    }
}
