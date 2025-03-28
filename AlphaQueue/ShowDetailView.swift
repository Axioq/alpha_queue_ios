//
//  ShowDetailView.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/21/25.
//

import SwiftUI

struct ShowDetailView: View {
    let tvShow: ShowSearchAPI.TVShow  // Passed in from the search results
    @State private var episodes: [EpisodesAPI.Episode] = []
    @State private var isLoading = false

    var body: some View {
        VStack {
            // Display the poster image, if available
            if let url = tvShow.posterURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                } placeholder: {
                    ProgressView()
                }
            }
            
            // Show title
            Text(tvShow.name)
                .font(.largeTitle)
                .padding()
            
            // Episodes list or loading indicator
            if isLoading {
                VStack{
                    ProgressView()
                    Text("Loading Episodes...")
                }
                .padding()
            } else {
                List(episodes) { ep in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Season \(ep.season), Episode \(ep.episode)")
                                .font(.headline)
                            if let title = ep.title, !title.isEmpty {
                                Text(title)
                                    .font(.subheadline)
                            }
                        }
                        Spacer()
                        Button(action: {
                            markEpisodeAsWatched(episode: ep)
                        }) {
                            Text("Mark Watched")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
        .navigationTitle(tvShow.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchEpisodes()
        }
    }
    
    // Fetch episodes for the given TV show using EpisodesAPI
    private func fetchEpisodes() {
        isLoading = true
        EpisodesAPI.shared.fetchEpisodes(for: tvShow.id) { eps in
            DispatchQueue.main.async {
                // Sort episodes by season and then episode number
                self.episodes = eps.sorted {
                    if $0.season == $1.season {
                        return $0.episode < $1.episode
                    }
                    return $0.season < $1.season
                }
                self.isLoading = false
            }
        }
    }
    
    // Mark an episode (and all previous ones, as per your business logic) as watched
    private func markEpisodeAsWatched(episode ep: EpisodesAPI.Episode) {
        ProgressAPI.shared.markEpisodeAsWatched(showID: tvShow.id,
                                                  name: tvShow.name,
                                                  season: ep.season,
                                                  episode: ep.episode) { success in
            DispatchQueue.main.async {
                if success {
                    print("Marked S\(ep.season) E\(ep.episode) as watched")
                    // Optionally, update the UI or refresh progress data
                } else {
                    print("Failed to mark episode as watched")
                }
            }
        }
    }
}

struct ShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview using dummy data from ShowSearchAPI.TVShow
        ShowDetailView(tvShow: ShowSearchAPI.TVShow(id: 123,
                                                    name: "Example Show",
                                                    poster_path: "/example.jpg"))
    }
}
