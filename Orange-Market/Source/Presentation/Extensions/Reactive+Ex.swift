//
//  Reactive+Ex.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/23.
//

import Foundation
import RxSwift
import Moya

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {
    
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Moya.Response> {
            return Single.create { [weak base] single in
                let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                    switch result {
                    case let .success(response):
                        single(.success(response))
                    case let .failure(error):
                        single(.failure(error))
                    }
                }

                return Disposables.create {
                    cancellableToken?.cancel()
                }
            }
        }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {

    /// Filters out responses that don't fall within the given closed range, generating errors when others are encountered.
    func filter<R: RangeExpression>(statusCodes: R) -> Single<Element> where R.Bound == Int {
        return flatMap { .just(try $0.filter(statusCodes: statusCodes)) }
    }

    /// Filters out responses that have the specified `statusCode`.
    func filter(statusCode: Int) -> Single<Element> {
        return flatMap { .just(try $0.filter(statusCode: statusCode)) }
    }

    /// Filters out responses where `statusCode` falls within the range 200 - 299.
    func filterSuccessfulStatusCodes() -> Single<Element> {
        return flatMap { .just(try $0.filterSuccessfulStatusCodes()) }
    }

    /// Filters out responses where `statusCode` falls within the range 200 - 399
    func filterSuccessfulStatusAndRedirectCodes() -> Single<Element> {
        return flatMap { .just(try $0.filterSuccessfulStatusAndRedirectCodes()) }
    }

    /// Maps data received from the signal into an Image. If the conversion fails, the signal errors.
    func mapImage() -> Single<Image> {
        return flatMap { .just(try $0.mapImage()) }
    }

    /// Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
    func mapJSON(failsOnEmptyData: Bool = true) -> Single<Any> {
        return flatMap { .just(try $0.mapJSON(failsOnEmptyData: failsOnEmptyData)) }
    }

    /// Maps received data at key path into a String. If the conversion fails, the signal errors.
    func mapString(atKeyPath keyPath: String? = nil) -> Single<String> {
        return flatMap { .just(try $0.mapString(atKeyPath: keyPath)) }
    }

    /// Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
        return flatMap { .just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}
