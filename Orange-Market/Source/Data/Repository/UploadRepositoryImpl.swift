//
//  UploadRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import Foundation
import RxSwift

class UploadRepositoryImpl: UploadRepository {
    
    private lazy var remote = UploadRemote()
    
    func uploadImage(image: UIImage) -> Single<String> {
        return remote.uploadImage(image: image)
    }
}
