//
//  ProductAPI.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Moya

enum ProductAPI {
    case getAllProduct(city: String)
}

extension ProductAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: HOST + "product/")!
    }
    
    var path: String {
        switch self {
            case .getAllProduct:
                return ""
        }
    }
    
    var method: Method {
        switch self {
            case .getAllProduct:
                return .get
        }
    }
    
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case let .getAllProduct(city):
                return .requestParameters(parameters: ["city": city], encoding: URLEncoding.queryString)
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
