//
//  TownLife.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/13.
//

import Moya

enum TownLifeAPI {
    case getAllTownLife(city: String)
    case getTownLife(idx: Int)
    case getAllComment(idx: Int)
    case saveTownLife(townLifeRequest: TownLifeRequest)
    case updateTownLife(idx: Int, townLifeRequest: TownLifeRequest)
    case deleteTownLife(idx: Int)
}

extension TownLifeAPI: TargetType {
    var baseURL: URL {
        return URL(string: HOST + "town/")!
    }
    
    var path: String {
        switch self {
            case .getAllTownLife:
                return ""
            case let .getTownLife(idx):
                return "\(idx)"
            case let .getAllComment(idx):
                return "comment/\(idx)"
            case .saveTownLife:
                return ""
            case let .updateTownLife(idx, _):
                return "\(idx)"
            case let .deleteTownLife(idx):
                return "\(idx)"
        }
    }
    
    var method: Method {
        switch self {
            case .getAllTownLife:
                return .get
            case .getTownLife:
                return .get
            case .getAllComment:
                return .get
            case .saveTownLife:
                return .post
            case .updateTownLife:
                return .put
            case .deleteTownLife:
                return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        case let .getAllTownLife(city):
            return .requestParameters(parameters: ["city": city], encoding: URLEncoding.queryString)
            
        case .getTownLife:
            return .requestPlain
            
        case .getAllComment:
            return .requestPlain
            
        case let .saveTownLife(townLifeRequest):
            return .requestData(try! JSONEncoder().encode(townLifeRequest))
            
        case let .updateTownLife(_, townLifeRequest):
            return .requestData(try! JSONEncoder().encode(townLifeRequest))
            
        case .deleteTownLife:
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
