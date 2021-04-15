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
        }
    }
    
    var method: Method {
        switch self {
            case .login:
                return .post
                
            case.register:
                return .post
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
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
        
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
