//
//  Environment.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation

final class Environment {
    public enum EnvironmentVariables: String {
        case apiBaseUrl = "API_BASE_URL"
    }
    
    public static func variable(_ key: EnvironmentVariables) -> String {
        guard let networkInfoPath = Bundle.main.path(forResource: "NetworkInfo", ofType: "plist") else { fatalError() }
        guard let networkInfoDict = NSDictionary(contentsOfFile: networkInfoPath) else { fatalError() }
        guard let value = networkInfoDict[key.rawValue] as? String else { fatalError() }
        return value
    }
}
