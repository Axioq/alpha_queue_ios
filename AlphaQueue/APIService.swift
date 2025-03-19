//
//  APIService.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/18/25.
//
import Foundation

struct ShowProgress: Codable, Identifiable {
    var id: String { "\(show_id)-S\(season)-E\(episode)" }
    let show_id: Int
    let name: String
    let season: Int
    let episode: Int
    let watched_at: String
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://api.wolflabs.dev"

    private var apiKey: String {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = plist["API_KEY"] as? String
        else {
            fatalError("❌ API Key not found in Secrets.plist")
        }
        return key
    }

    func fetchProgress(completion: @escaping ([ShowProgress]) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/progress?token=\(apiKey)") else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ API error: \(error)")
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            do {
                let progress = try JSONDecoder().decode([ShowProgress].self, from: data)
                DispatchQueue.main.async {
                    completion(progress)
                }
            } catch {
                print("❌ JSON decoding error: \(error)")
            }
        }.resume()
    }
}
