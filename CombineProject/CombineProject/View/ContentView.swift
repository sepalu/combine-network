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
        NavigationStack {
            VStack {
                TextField("Search", text: $vm.searchQuery)
                    .textFieldStyle(.roundedBorder)
                
                List(vm.songs, id: \.id) { song in
                    NavigationLink {
                        if let songToDisplay = vm.songs.first(where: { $0.id == song.id}) {
                            if let songDetails = songToDisplay.attributes {
                                SongDetailsView(song: songDetails)
                            }
                        }
                    } label: {
                        if let songDetails = song.attributes {
                            SongRowView(song: songDetails)
                        }
                    }

                }
                .listStyle(.inset)
                
                Spacer()
            }
            .padding()
        }
        .environmentObject(vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
