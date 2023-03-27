//
//  Song.swift
//  CombineProject
//
//  Created by Serena on 25/03/23.
//

import Foundation

struct SearchResponse: Decodable {
    let meta: Meta
    let response: Response
}

struct Meta: Decodable {
    let status: Int
}

struct Response: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let result: Result
}

struct Result: Decodable {
    let apiPath, artistNames, fullTitle: String
    let id: Int
    let releaseDateComponents: ReleaseDateComponents
    let songArtImageThumbnailURL, songArtImageURL: String
    let title: String
    let primaryArtist: PrimaryArtist
    
    enum CodingKeys: String, CodingKey {
        case apiPath = "api_path"
        case artistNames = "artist_names"
        case fullTitle = "full_title"
        case id
        case releaseDateComponents = "release_date_components"
        case songArtImageThumbnailURL = "song_art_image_thumbnail_url"
        case songArtImageURL = "song_art_image_url"
        case title
        case primaryArtist = "primary_artist"
    }
}

struct PrimaryArtist: Codable {
    let id: Int
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id
        case name, url
    }
}

struct ReleaseDateComponents: Codable {
    let year, month, day: Int
}

//struct Result: Codable {
////    let apiPath, artistNames, fullTitle: String
////    let headerImageThumbnailURL, headerImageURL: String
//    let id: Int
////    let releaseDateComponents: ReleaseDateComponents
////    let songArtImageThumbnailURL, songArtImageURL: String
////    let title, titleWithFeatured: String
////    let primaryArtist: PrimaryArtist
////
////    enum CodingKeys: String, CodingKey {
////        case apiPath = "api_path"
////        case artistNames = "artist_names"
////        case fullTitle = "full_title"
////        case headerImageThumbnailURL = "header_image_thumbnail_url"
////        case headerImageURL = "header_image_url"
////        case id
////        case releaseDateComponents = "release_date_components"
////        case songArtImageThumbnailURL = "song_art_image_thumbnail_url"
////        case songArtImageURL = "song_art_image_url"
////        case title
////        case titleWithFeatured = "title_with_featured"
////        case primaryArtist = "primary_artist"
////    }
//}
