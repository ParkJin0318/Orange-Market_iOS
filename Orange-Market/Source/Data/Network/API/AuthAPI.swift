//
//  AuthAPI.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Moya

enum AuthAPI {
    case login(loginRequest: LoginRequest)
    case register(registerRequest: RegisterRequest)
    case getUserProfile
}

extension AuthAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: HOST + "auth/")!
    }
    
    var path: String {
        switch self {
            case .login:
                return "login"
                
            case .register:
                return "register"
                
            case .getUserProfile:
                return "profile"
        }
    }
    
    var method: Method {
        switch self {
            case .login:
                return .post
                
            case.register:
                return .post
                
            case .getUserProfile:
                return .get
        }
    }
    
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case let .login(loginRequest):
                return .requestData(try! JSONEncoder().encode(loginRequest))
                
            case let .register(registerRequest):
                return .requestData(try! JSONEncoder().encode(registerRequest))
                
            case .getUserProfile:
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
