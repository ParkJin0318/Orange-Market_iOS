//
//  Error.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/15.
//

import Foundation

enum OrangeError: Error {
    case error(message: String)
}

extension Error {
    func toMessage() -> String {
        if let error = self as? OrangeError,
            case let .error(message) = error {
                return message
        } else {
            return "알 수 없는 오류"
        }
    }
}
