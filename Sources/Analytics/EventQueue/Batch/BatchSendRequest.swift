//
//  BatchSendRequest.swift
//  PaltaAnalytics
//
//  Created by Vyacheslav Beltyukov on 15/06/2022.
//

import Foundation
import PaltaCore

struct BatchSendRequest {
    let host: URL?
    let time: Int
    let data: Data
}

extension BatchSendRequest: AutobuildingHTTPRequest {
    var method: HTTPMethod {
        .post
    }
    
    var baseURL: URL {
        host ?? Constants.defaultBaseURL
    }
    
    var path: String? {
        "/v2/paltabrain"
    }
    
    var headers: [String : String]? {
        [
            "X-Client-Upload-TS": "\(time)",
            "Content-Type": "application/protobuf"
        ]
    }
    
    var body: Data? {
        data
    }
}
