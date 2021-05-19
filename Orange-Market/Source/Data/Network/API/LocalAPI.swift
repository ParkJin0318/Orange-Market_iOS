//
//  LocalAPI.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/13.
//

import Moya

enum LocalAPI {
    case getAllPost(city: String)
    case getPost(idx: Int)
    case getAllComment(idx: Int)
    case savePost(townLifeRequest: LocalPostRequest)
    case saveComment(localCommentRequest: LocalCommentRequest)
    case updatePost(idx: Int, townLifeRequest: LocalPostRequest)
    case deletePost(idx: Int)
    case deleteComment(idx: Int)
}

extension LocalAPI: TargetType {
    var baseURL: URL {
        return URL(string: HOST + "local/")!
    }
    
    var path: String {
        switch self {
            case .getAllPost:
                return ""
            case let .getPost(idx):
                return "\(idx)"
            case let .getAllComment(idx):
                return "comment/\(idx)"
            case .savePost:
                return ""
            case .saveComment:
                return "comment"
            case let .updatePost(idx, _):
                return "\(idx)"
            case let .deletePost(idx):
                return "\(idx)"
            case let .deleteComment(idx):
                return "comment/\(idx)"
        }
    }
    
    var method: Method {
        switch self {
            case .getAllPost:
                return .get
            case .getPost:
                return .get
            case .getAllComment:
                return .get
            case .savePost:
                return .post
            case .saveComment:
                return .post
            case .updatePost:
                return .put
            case .deletePost:
                return .delete
            case .deleteComment:
                return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case let .getAllPost(city):
                return .requestParameters(parameters: ["city": city], encoding: URLEncoding.queryString)
                
            case .getPost:
                return .requestPlain
                
            case .getAllComment:
                return .requestPlain
                
            case let .savePost(request):
                return .requestData(try! JSONEncoder().encode(request))
                
            case let .saveComment(request):
                return .requestData(try! JSONEncoder().encode(request))
                
            case let .updatePost(_, request):
                return .requestData(try! JSONEncoder().encode(request))
                
            case .deletePost:
                return .requestPlain
                
            case .deleteComment:
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
