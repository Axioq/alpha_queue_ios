//
//  ProgressView.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/27/25.
//

import SwiftUI

struct ProgressView: View {
    @State private var progressList: [ProgressAPI.ShowProgress] = []
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    VStack{
                        ProgressView()
                        Text("Loading Episodes...")
                    }
                    .padding()
                } else {
                    List(progressList) { progress in
                        VStack(alignment: .leading) {
                            Text(progress.name)
                                .font(.headline)
                            Text("Season \(progress.season), Episode \(progress.episode)")
                                .font(.subheadline)
                            Text("Watched at: \(progress.watched_at)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Progress")
            .onAppear {
                fetchProgress()
            }
        }
    }
    
    private func fetchProgress() {
        isLoading = true
        ProgressAPI.shared.fetchProgress { result in
            self.progressList = result
            self.isLoading = false
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
