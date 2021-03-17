//
//  UploadAPI.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import Moya

enum UploadAPI {
    case uploadImage(file: [MultipartFormData])
}

extension UploadAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: HOST + "upload/")!
    }
    
    var path: String {
        switch self {
            case .uploadImage:
                return "image"
        }
    }
    
    var method: Method {
        switch self {
            case .uploadImage:
                return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .uploadImage(file):
            return .uploadMultipart(file)
        }
    }
        
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
            
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        headers["token"] = AuthController.getInstance().getToken()
        return headers
    }
}
