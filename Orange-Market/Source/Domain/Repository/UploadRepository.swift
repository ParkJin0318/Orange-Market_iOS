//
//  UploadRepository.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import Foundation
import RxSwift

protocol UploadRepository {
    func uploadImage(image: UIImage) -> Single<String>
}
