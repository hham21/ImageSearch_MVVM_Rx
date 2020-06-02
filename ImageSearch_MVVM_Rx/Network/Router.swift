//
//  Router.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import RxSwift
import RxAlamofire

enum Router {
    case imageSearch(Query)
}

extension Router {
    var path: String {
        switch self {
        case .imageSearch:
            return "/v2/search/image"
        }
    }
    
    var queryItem: [URLQueryItem] {
        switch self {
        case .imageSearch(let query):
            return [
                URLQueryItem(name: Constant.query, value: query.text),
                URLQueryItem(name: Constant.page, value: "\(query.page)")
            ]
        }
    }
    
    var componets: URLComponents {
        var components = URLComponents()
        components.scheme = API.Constant.scheme
        components.host = API.Constant.host
        components.path = path
        components.queryItems = queryItem
        return components
    }
    
    var url: URL? {
        return componets.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil}
        var request = URLRequest(url: url)
        request.addValue(API.Constant.apikey, forHTTPHeaderField: Constant.authorization)
        return request
    }
    
    func request() -> Observable<Data> {
        guard let urlRequest = urlRequest else {
            return .error(APIError.urlRequestCreationFailed)
        }
        return RxAlamofire
            .request(urlRequest)
            .validate()
            .data()
    }
}
