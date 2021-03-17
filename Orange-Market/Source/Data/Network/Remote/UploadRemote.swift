//
//  UploadRemote.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import RxSwift
import Moya

class UploadRemote {
    
    private lazy var provider: MoyaProvider<UploadAPI> = MoyaProvider()
    
    func uploadImage(image: UIImage) -> Single<String> {
        let file = self.getMultipartImage(image: image)
        
        return provider.rx.request(.uploadImage(file: file))
            .map(Response<String>.self, using: JSONDecoder())
            .map { response -> String in
                return response.data
            }
    }
    
    private func getMultipartImage(image: UIImage) -> [MultipartFormData] {
        let imageData = MultipartFormData(
            provider: .data(image.jpegData(compressionQuality: 0.2)!),
            name: "file",
            fileName: "file.jpeg",
            mimeType: .none
        )
        
        let descriptionData = MultipartFormData(
            provider: .data("image".data(using: String.Encoding.utf8)!),
            name: "file"
        )
        return [imageData, descriptionData]
    }
}
