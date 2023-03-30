//
//  SongResponse.swift
//  CombineProject
//
//  Created by Serena on 29/03/23.
//

import Foundation

struct AlbumResponse: Codable {
    let data: [AlbumDatum]
}

struct AlbumDatum: Codable {
    let id: String
    let href: String
    let attributes: AlbumAttributes
}

struct AlbumAttributes: Codable {
    let copyright: String
    let genreNames: [String]
    let releaseDate: String
    let isMasteredForItunes: Bool
    let upc: String
    let artwork: Artwork
    let url: String
    let trackCount: Int
    let name: String
}
