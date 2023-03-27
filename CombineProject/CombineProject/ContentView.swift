//
//  ContentView.swift
//  CombineProject
//
//  Created by Serena on 25/03/23.
//

/**
 
 Use the Genius API to:
 - search for a song (through title or artist)
 - select a song
 - retrieve info and curiosity about it
 
 **/

import SwiftUI

struct ContentView: View {
    @StateObject var vm = SongsViewModel()
    
    var body: some View {
        VStack {
            TextField("Search", text: $vm.searchQuery)
            
            ForEach(Array(vm.songs.enumerated()), id: \.offset) { index, song in
                Text(song.result.fullTitle)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
