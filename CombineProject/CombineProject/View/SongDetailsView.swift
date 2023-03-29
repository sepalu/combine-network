//
//  SongDetailsView.swift
//  CombineProject
//
//  Created by Serena on 29/03/23.
//

import SwiftUI

struct SongDetailsView: View {
    let song: ResponseSong
    
    var body: some View {
        NavigationStack {
            VStack {
                AsyncImage(url: URL(string: song.headerImageURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 400)
                
                Text(song.primaryArtist.name)
                    .fontWeight(.semibold)
            }
            .navigationTitle(song.fullTitle)
        }
    }
}

//struct SongDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongDetailsView()
//    }
//}
