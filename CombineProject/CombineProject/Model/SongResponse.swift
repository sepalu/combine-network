//
//  SongResponse.swift
//  CombineProject
//
//  Created by Serena on 29/03/23.
//

import Foundation

struct SongResponse: Codable {
    let meta: Meta
    let response: Response
    
    struct Meta: Codable {
        let status: Int
    }

    struct Response: Codable {
        let song: ResponseSong
    }
}

struct ResponseSong: Codable {
    let apiPath: String
    let artistNames: String
    let fullTitle: String
    let headerImageThumbnailURL, headerImageURL: String
    let id: Int
    let path: String
    let songArtImageThumbnailURL, songArtImageURL: String
    let title, titleWithFeatured: String
    let url: String
    let album: Album
    let primaryArtist: Artist

    enum CodingKeys: String, CodingKey {
        case apiPath = "api_path"
        case artistNames = "artist_names"
        case fullTitle = "full_title"
        case headerImageThumbnailURL = "header_image_thumbnail_url"
        case headerImageURL = "header_image_url"
        case id
        case path
        case songArtImageThumbnailURL = "song_art_image_thumbnail_url"
        case songArtImageURL = "song_art_image_url"
        case title
        case titleWithFeatured = "title_with_featured"
        case url
        case album
        case primaryArtist = "primary_artist"
    }
}

struct Album: Codable {
    let apiPath: String
    let coverArtURL: String
    let fullTitle: String
    let id: Int
    let name, releaseDateForDisplay: String
    let url: String
    let artist: Artist

    enum CodingKeys: String, CodingKey {
        case apiPath = "api_path"
        case coverArtURL = "cover_art_url"
        case fullTitle = "full_title"
        case id, name
        case releaseDateForDisplay = "release_date_for_display"
        case url, artist
    }
}

struct Artist: Codable {
    let apiPath: String
    let headerImageURL: String
    let id: Int
    let imageURL: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case apiPath = "api_path"
        case headerImageURL = "header_image_url"
        case id
        case imageURL = "image_url"
        case name
    }
}
