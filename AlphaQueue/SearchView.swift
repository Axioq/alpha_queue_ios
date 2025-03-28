//
//  SearchView.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/21/25.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    @State private var shows: [ShowSearchAPI.TVShow] = []
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    TextField("Search TV shows...", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        search()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical)
                
                // Loading indicator
                if isLoading {
                    VStack{
                        ProgressView()
                        Text("Loading Episodes...")
                    }
                    .padding()
                }
                
                // List of search results
                List(shows) { show in
                    NavigationLink(destination: ShowDetailView(tvShow: show)) {
                        HStack {
                            // Load the poster image (if available)
                            if let url = show.posterURL {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image(systemName: "film")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80)
                            }
                            
                            Text(show.name)
                                .font(.headline)
                                .padding(.leading, 8)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Search Shows")
        }
    }
    
    private func search() {
        guard !query.isEmpty else { return }
        isLoading = true
        print("Searching for: \(query)")
        ShowSearchAPI.shared.searchTVShows(query: query) { result in
            DispatchQueue.main.async {
                print("Received \(result.count) results")
                self.shows = result
                self.isLoading = false
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
