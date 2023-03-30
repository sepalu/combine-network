//
//  SongDetailsView.swift
//  CombineProject
//
//  Created by Serena on 29/03/23.
//

import SwiftUI

struct SongDetailsView: View {
    @EnvironmentObject var vm: SongsViewModel
    let song: SongAttributes
    
    var songUrl: String {
        var urlString = song.artwork.url
        let width = 400
        let height = 400

        urlString = urlString.replacingOccurrences(of: "{w}", with: "\(width)")
        urlString = urlString.replacingOccurrences(of: "{h}", with: "\(height)")
        
        return urlString
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                AsyncImage(url: URL(string: song.artwork.url)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 400, height: 400)
                
                Text("Other albums from \(song.artistName ?? "no artist name")")
                    .fontWeight(.semibold)
                
                List(vm.albums, id: \.id) { album in
                    Text(album.attributes.name)
                }
            }
            .navigationTitle(song.name)
        }
    }
}

//struct SongDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongDetailsView()
//    }
//}
