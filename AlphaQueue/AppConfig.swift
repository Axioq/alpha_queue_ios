//
//  Config.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/27/25.
//

import Foundation

struct AppConfig {
    static var baseURL: String {
        guard let url = getConfigValue(for: "BaseURL") else {
            fatalError("BaseURL not found in Config.plist")
        }
        return url
    }
    
    static var tmdbImageBaseURL: String {
        guard let url = getConfigValue(for: "TMDBImageBaseURL") else {
            fatalError("TMDBImageBaseURL not found in Config.plist")
        }
        return url
    }
    
    private static func getConfigValue(for key: String) -> String? {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let value = dict[key] as? String {
            return value
        }
        return nil
    }
}
