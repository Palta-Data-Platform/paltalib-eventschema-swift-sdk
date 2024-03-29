//
//  PublicFormattersTests.swift
//  
//
//  Created by Vyacheslav Beltyukov on 17/05/2023.
//

import PaltaAnalytics
import XCTest

final class PublicFormattersTests: XCTestCase {
    func testDate() {
        let string = PaltaAnalytics.Formatters.timestampFormatter.string(from: 733094701805)
        
        XCTAssertEqual(
            string,
            "1993-03-25 21:25:01.805"
        )
    }
    
    func testDateZeroes() {
        let string = PaltaAnalytics.Formatters.timestampFormatter.string(from: 1568505600000)
        
        XCTAssertEqual(
            string,
            "2019-09-15 00:00:00.000"
        )
    }
    
    func testRoundDecimal() {
        let decimal: Decimal = 9856874665
        let string = PaltaAnalytics.Formatters.decimalFormatter.string(from: decimal as NSDecimalNumber)
        
        XCTAssertEqual(
            string,
            "9856874665"
        )
    }
    
    func testDecimal() {
        let decimal: Decimal = 9856874.665
        let string = PaltaAnalytics.Formatters.decimalFormatter.string(from: decimal as NSDecimalNumber)
        
        XCTAssertEqual(
            string,
            "9856874.665"
        )
    }
    
    func testNonDouble() {
        let decimal: Decimal = 1.017
        let string = PaltaAnalytics.Formatters.decimalFormatter.string(from: decimal as NSDecimalNumber)
        
        XCTAssertEqual(
            string,
            "1.017"
        )
    }
}
