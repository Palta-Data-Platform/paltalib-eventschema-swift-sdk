//
//  BatchSendRequestTests.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 15/06/2022.
//

import Foundation
import XCTest
import PaltaAnalyticsModel
@testable import PaltaAnalytics

final class BatchSendRequestTests: XCTestCase {
    func testBuildRequest() {
        let data = Data((0...20).map { _ in UInt8.random(in: UInt8.min...UInt8.max) })
        let request = BatchSendRequest(
            host: URL(string: "ftp://mock.url")!,
            time: 878,
            errorCodes: [1001, 5012, 2890],
            data: data
        )
        
        let urlRequest = request.urlRequest(headerFields: ["DEFAULT_HEADER": "DEFAULT_HEADER_VALUE"])
        
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url, URL(string: "ftp://mock.url/v2/paltabrain"))
        XCTAssertEqual(
            urlRequest?.allHTTPHeaderFields,
            [
                "X-SDK-Client-Upload-TS": "878",
                "DEFAULT_HEADER": "DEFAULT_HEADER_VALUE",
                "Content-Type": "application/protobuf",
                "X-SDK-Network-Errors": "1001,5012,2890"
            ]
        )
        XCTAssertEqual(urlRequest?.httpBody, data)
    }
}
