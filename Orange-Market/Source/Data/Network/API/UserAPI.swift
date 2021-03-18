//
//  UserAPI.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Moya

enum UserAPI {
    case getUserInfo(idx: Int)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: HOST + "user/")!
    }
    
    var path: String {
        switch self {
            case let .getUserInfo(idx):
                return "\(idx)"
        }
    }
    
    var method: Method {
        switch self {
            case .getUserInfo:
                return .get
        }
    }
    
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .getUserInfo:
                return .requestPlain
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
