//
//  ContentView.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/18/25.
//
import SwiftUI

struct ContentView: View {
    @State private var progressList: [ShowProgress] = []

    var body: some View {
        NavigationView {
            List(progressList) { item in
                VStack(alignment: .leading) {
                    Text(item.name).font(.headline)
                    Text("S\(item.season) E\(item.episode)")
                    Text("Watched at \(item.watched_at)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("TV Progress")
            .onAppear {
                APIService.shared.fetchProgress { progress in
                    self.progressList = progress
                }
            }
        }
    }
}
