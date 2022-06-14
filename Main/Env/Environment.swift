//
//  Environment.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation

public final class Environment {
    public enum EnvironmentVariables: String {
        case apiBaseUrl = "API_BASE_URL"
    }
    
    public static func variable(_ key: EnvironmentVariables) -> String {
        guard let value = Bundle.main.infoDictionary![key.rawValue] as? String else { fatalError() }
        return value
    }
}
