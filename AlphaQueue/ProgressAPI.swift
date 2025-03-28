//
//  ProgressAPI.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/27/25.
//

import Foundation

class ProgressAPI {
    static let shared = ProgressAPI()
    
    private let baseURL = AppConfig.baseURL
    
    // MARK: - Model for Progress
    struct ShowProgress: Codable, Identifiable {
        var id: String { "\(show_id)-S\(season)-E\(episode)" }
        let show_id: Int
        let name: String
        let season: Int
        let episode: Int
        let watched_at: String
    }
    
    // MARK: - Fetch All Progress
    func fetchProgress(completion: @escaping ([ShowProgress]) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/progress?token=\(AppConfig.apiKey)") else {
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
                let progress = try JSONDecoder().decode([ShowProgress].self, from: data)
                DispatchQueue.main.async {
                    completion(progress)
                }
            } catch {
                print("❌ JSON decoding error: \(error)")
                completion([])
            }
        }.resume()
    }
    
    // MARK: - Mark an Episode as Watched
    // This function posts progress data to the backend.
    func markEpisodeAsWatched(showID: Int, name: String, season: Int, episode: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/progress?token=\(AppConfig.apiKey)") else {
            print("❌ Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "show_id": showID,
            "name": name,
            "season": season,
            "episode": episode
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error marking as watched: \(error)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}
