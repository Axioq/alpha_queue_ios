//
//  ContentView.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/18/25.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            ProgressView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Progress")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
