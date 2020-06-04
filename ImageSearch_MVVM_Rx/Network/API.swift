//
//  API.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import RxSwift

typealias Query = (text: String, page: Int)
typealias SearchResult = Observable<Result<SearchResponse, APIError>>

enum APIError: Error {
    case urlRequestCreationFailed
    case searchResponseParsingFailed
    case error(String)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .error(let desc):
            return desc
        case .urlRequestCreationFailed:
            return "url request creation failed"
        case .searchResponseParsingFailed:
            return "SearchResponse parsing failed"
        }
    }
}

protocol APIProtocol {
    func getImages(query: Query) -> SearchResult
}

struct API: APIProtocol {
    struct Constant {
        static let scheme = "https"
        static let host = "dapi.kakao.com"
        static let apikey = "KakaoAK f5f425aa7f32d42b1cd464aa09f58b3c"
    }
    
    func getImages(query: Query) -> SearchResult {
        Router
            .imageSearch(query)
            .request()
            .catchErrorJustReturn(.empty)
            .map { data in
                do {
                    let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                    return .success(response)
                } catch {
                    return Result.failure(.searchResponseParsingFailed)
                }
            }
    }
}
