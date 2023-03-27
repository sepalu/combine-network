//
//  SongRowView.swift
//  CombineProject
//
//  Created by Serena on 27/03/23.
//

import SwiftUI

struct SongRowView: View {
    let song: Result
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: song.songArtImageThumbnailURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            
            Text(song.fullTitle)
                .fontWeight(.semibold)
        }
    }
}

//struct SongRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongRowView()
//    }
//}
