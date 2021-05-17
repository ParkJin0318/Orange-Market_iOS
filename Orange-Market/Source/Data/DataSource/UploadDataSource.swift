//
//  UploadDataSource.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/17.
//

import Foundation
import RxSwift

class UploadDataSource {
    
    private lazy var remote = UploadRemote()
    
    func uploadImage(image: UIImage) -> Single<String> {
        return remote.uploadImage(image: image)
    }
}
