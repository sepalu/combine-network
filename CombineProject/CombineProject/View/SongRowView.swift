//
//  SongRowView.swift
//  CombineProject
//
//  Created by Serena on 27/03/23.
//

import SwiftUI

struct SongRowView: View {
    let song: SongAttributes
    
    var songUrl: String {
        var urlString = song.artwork.url
        let width = 40
        let height = 40

        urlString = urlString.replacingOccurrences(of: "{w}", with: "\(width)")
        urlString = urlString.replacingOccurrences(of: "{h}", with: "\(height)")
        
        return urlString
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: songUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            
            Text(song.name)
                .fontWeight(.semibold)
        }
    }
}

//struct SongRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongRowView()
//    }
//}
