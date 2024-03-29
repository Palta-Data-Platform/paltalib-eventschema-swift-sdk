//
//  SDKInfoProvider.swift
//  PaltaAnalytics
//
//  Created by Vyacheslav Beltyukov on 15/06/2022.
//

import Foundation

protocol SDKInfoProvider {
    var sdkName: String { get }
    var sdkVersion: String { get }
}

final class SDKInfoProviderImpl: SDKInfoProvider {
    var sdkName: String {
        "PALTABRAIN_IOS"
    }
    
    var sdkVersion: String {
        global_sdkVersion
    }
}
