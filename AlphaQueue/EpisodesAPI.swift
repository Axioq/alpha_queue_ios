//
//  EpisodesAPI.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/27/25.
//

import Foundation

class EpisodesAPI {
    static let shared = EpisodesAPI()
    private let baseURL = AppConfig.baseURL
    
    // MARK: - Episode Model
    struct Episode: Codable, Identifiable {
        // Create a unique ID from season and episode numbers
        var id: String { "\(season)-\(episode)" }
        let season: Int
        let episode: Int
        let title: String?
        let air_date: String?
    }
    
    // MARK: - Fetch Episodes for a Given Show
    func fetchEpisodes(for showID: Int, completion: @escaping ([Episode]) -> Void) {
        // Assumes your endpoint is structured as /api/episodes/<show_id>?token=...
        guard let url = URL(string: "\(baseURL)/api/episodes/\(showID)?token=\(AppConfig.apiKey)") else {
            print("❌ Invalid URL for episodes")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching episodes: \(error)")
                completion([])
                return
            }
            guard let data = data else {
                print("❌ No data received for episodes")
                completion([])
                return
            }
            do {
                let episodes = try JSONDecoder().decode([Episode].self, from: data)
                DispatchQueue.main.async {
                    completion(episodes)
                }
            } catch {
                print("❌ JSON decoding error in episodes: \(error)")
                completion([])
            }
        }.resume()
    }
}
