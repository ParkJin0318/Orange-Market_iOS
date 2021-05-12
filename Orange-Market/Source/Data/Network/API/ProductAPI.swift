//
//  ProductAPI.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Moya

enum ProductAPI {
    case getAllProduct(city: String)
    case getAllLikeProduct
    case getProduct(idx: Int)
    case getAllCategory
    case saveProduct(productRequest: ProductRequest)
    case likeProduct(idx: Int)
    case updateProduct(idx: Int, productRequest: ProductRequest)
    case updateSold(idx: Int)
    case deleteProduct(idx: Int)
}

extension ProductAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: HOST + "product/")!
    }
    
    var path: String {
        switch self {
            case .getAllProduct:
                return ""
            case .getAllLikeProduct:
                return "like"
            case let .getProduct(idx):
                return "\(idx)"
            case .getAllCategory:
                return "category"
            case .saveProduct:
                return ""
            case let .likeProduct(idx):
                return "like/\(idx)"
            case let .updateProduct(idx, _):
                return "\(idx)"
            case let .updateSold(idx):
                return "sold/\(idx)"
            case let .deleteProduct(idx):
                return "\(idx)"
        }
    }
    
    var method: Method {
        switch self {
            case .getAllProduct:
                return .get
            case .getAllLikeProduct:
                return .get
            case .getProduct:
                return .get
            case .getAllCategory:
                return .get
            case .saveProduct:
                return .post
            case .likeProduct:
                return .post
            case .updateProduct:
                return .put
            case .updateSold:
                return .put
            case .deleteProduct:
                return .delete
        }
    }
    
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case let .getAllProduct(city):
                return .requestParameters(parameters: ["city": city], encoding: URLEncoding.queryString)
                
            case .getAllLikeProduct:
                return .requestPlain
                
            case .getProduct:
                return .requestPlain
                
            case .getAllCategory:
                return .requestPlain
                
            case let .saveProduct(productRequest):
                return .requestData(try! JSONEncoder().encode(productRequest))
                
            case let .likeProduct(idx):
                return .requestPlain
                
            case let .updateProduct(_, productRequest):
                return .requestData(try! JSONEncoder().encode(productRequest))
                
            case .updateSold:
                return .requestPlain
                
            case .deleteProduct:
                return .requestPlain
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
        
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        headers["Authorization"] = AuthController.getInstance().getToken()
        return headers
    }
}
