//
//  ShowSearchAPI.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/27/25.
//

import Foundation

class ShowSearchAPI {
    static let shared = ShowSearchAPI()
    
    // Use configuration from AppConfig
    private let baseURL = AppConfig.baseURL
    
    // MARK: - TV Show Models
    struct TVShow: Codable, Identifiable {
        let id: Int
        let name: String
        let poster_path: String?
        
        // Construct full URL using the image base URL from AppConfig
        var posterURL: URL? {
            guard let path = poster_path else { return nil }
            return URL(string: "\(AppConfig.tmdbImageBaseURL)\(path)")
        }
    }
    
    struct TVShowSearchResponse: Codable {
        let results: [TVShow]
    }
    
    // MARK: - API for Searching Shows
    func searchTVShows(query: String, completion: @escaping ([TVShow]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/api/search?query=\(encodedQuery)&token=\(AppConfig.apiKey)") else {
            print("❌ Invalid URL")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ API error: \(error)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                completion([])
                return
            }
            
            do {
                let searchResponse = try JSONDecoder().decode(TVShowSearchResponse.self, from: data)
                completion(searchResponse.results)
            } catch {
                print("❌ JSON decoding error: \(error)")
                completion([])
            }
        }.resume()
    }
}
