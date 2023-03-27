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
 - retrieve info and curiosities about it
 
 **/

import SwiftUI

struct ContentView: View {
    @StateObject var vm = SongsViewModel()
    
    var body: some View {
        VStack {
            TextField("Search", text: $vm.searchQuery)
                .textFieldStyle(.roundedBorder)
            
            List(vm.songs, id: \.result.id) { song in
                SongRowView(song: song.result)
            }
            .listStyle(.inset)
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
