//
//  Config.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/27/25.
//

import Foundation

struct AppConfig {
    // Non-sensitive configuration from Config.plist
    static var baseURL: String {
        guard let value = getConfigValue(for: "BaseURL", from: "Config") else {
            fatalError("BaseURL not found in Config.plist")
        }
        return value
    }
    
    static var tmdbImageBaseURL: String {
        guard let value = getConfigValue(for: "TMDBImageBaseURL", from: "Config") else {
            fatalError("TMDBImageBaseURL not found in Config.plist")
        }
        return value
    }
    
    // Sensitive configuration from Secrets.plist
    static var apiKey: String {
        guard let value = getConfigValue(for: "API_KEY", from: "Secrets") else {
            fatalError("API_KEY not found in Secrets.plist")
        }
        return value
    }
    
    private static func getConfigValue(for key: String, from plistName: String) -> String? {
        if let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let value = dict[key] as? String {
            return value
        }
        return nil
    }
}
