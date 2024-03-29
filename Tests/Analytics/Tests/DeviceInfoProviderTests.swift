//
//  DeviceInfoProviderTests.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 11.04.2022.
//

import XCTest
@testable import PaltaAnalytics

final class DeviceInfoProviderTests: XCTestCase {
    var infoProvider: DeviceInfoProviderImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()

        infoProvider = .init()
    }

//    func testCountry() {
//        XCTAssertEqual(infoProvider.country, "CY")
//    }
//
//    func testLanguage() {
//        XCTAssertEqual(infoProvider.language, "el")
//    }

    func testDevice() {
        // Run on simulator only!
        XCTAssertEqual(infoProvider.deviceModel, "iPhone Simulator")
    }

    func testNoCarrier() {
        XCTAssertEqual(infoProvider.carrier, "Unknown")
    }

    func testTimezone() {
        XCTAssert((-12*3600...12*3600).contains(infoProvider.timezoneOffsetSeconds))
    }
}
