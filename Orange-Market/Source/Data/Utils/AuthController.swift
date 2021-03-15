//
//  AuthController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation

class AuthController {
    
    let tokenKey = "token"
    let preferences = UserDefaults.standard
    
    func login(token:String){
        preferences.set(token, forKey: tokenKey)
    }
    
    func logout(){
        preferences.set(nil, forKey: tokenKey)
    }
    
    func getToken() -> String {
        return preferences.value(forKey: tokenKey) as? String ?? ""
    }
}

extension AuthController {
    
    static var authController:AuthController!
    
    static func getInstance() -> AuthController {
        
        if (AuthController.authController == nil) {
            AuthController.authController = AuthController()
        }
        return .authController
    }
}
