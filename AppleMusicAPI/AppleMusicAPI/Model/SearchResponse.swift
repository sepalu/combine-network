//
//  Song.swift
//  CombineProject
//
//  Created by Serena on 25/03/23.
//

import Foundation

struct SearchResponse: Codable {
    let results: SearchResponseResults
    let meta: Meta
}

struct Meta: Codable {
    let results: MetaResults
}

struct MetaResults: Codable {
    let order, rawOrder: [Order]
}

enum Order: String, Codable {
    case albums = "albums"
    case artists = "artists"
    case musicVideos = "music-videos"
    case playlists = "playlists"
    case songs = "songs"
}

struct SearchResponseResults: Codable {
    let songs, albums, playlists, musicVideos: MusicVideosClass
    let artists: Artists

    enum CodingKeys: String, CodingKey {
        case songs, albums, playlists
        case musicVideos = "music-videos"
        case artists
    }
}

struct MusicVideosClass: Codable {
    let data: [SearchResponseDatum]
}

struct SearchResponseDatum: Codable {
    let id: String
    let type: Order
    let href: String
    let attributes: SongAttributes?
}

struct SongAttributes: Codable {
    let trackCount: Int?
    let name: String
    let artistName: String?
    let artwork: Artwork
    let albumName: String?
    let composerName: String?
    let discNumber: Int?
}

struct Artwork: Codable {
    let width, height: Int
    let url: String
    let bgColor, textColor1, textColor2, textColor3: String?
    let textColor4: String?
}

struct Artists: Codable {
    let href, next: String
    let data: [ArtistsDatum]
}

struct ArtistsDatum: Codable {
    let id: String
    let type: Order
    let href: String
    let attributes: ArtistAttributes
}

struct ArtistAttributes: Codable {
    let name: String
    let genreNames: [String]
    let url: String
}
