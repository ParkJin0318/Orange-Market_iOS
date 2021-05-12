//
//  UserAPI.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Moya

enum UserAPI {
    case getUserInfo(idx: Int)
    case getUserProfile
    case updateLocation(locationRequest: LocationRequest)
    case updateUserProfile(userRequest: UserRequest)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: HOST + "user/")!
    }
    
    var path: String {
        switch self {
            case let .getUserInfo(idx):
                return "\(idx)"
            case .getUserProfile:
                return "profile"
            case .updateLocation:
                return "location"
            case .updateUserProfile:
                return "profile"
        }
    }
    
    var method: Method {
        switch self {
            case .getUserInfo:
                return .get
            case .getUserProfile:
                return .get
            case .updateLocation:
                return .post
            case .updateUserProfile:
                return .post
        }
    }
    
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .getUserInfo:
                return .requestPlain
            case .getUserProfile:
                return .requestPlain
            case let .updateLocation(locationRequest):
                return .requestData(try! JSONEncoder().encode(locationRequest))
            case let .updateUserProfile(userRequest):
                return .requestData(try! JSONEncoder().encode(userRequest))
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
