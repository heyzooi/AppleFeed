//
//  Album.swift
//  
//
//  Created by Victor Hugo Carvalho Barros on 2019-10-26.
//

import Foundation

public struct AlbumGenre: Decodable {
    
    public let genreId: String
    public let name: String
    public let url: String
    
}

public struct Album: Decodable {
    
    public let id: String
    public let artistName: String
    public let releaseDate: Date
    public let name: String
    public let kind: String
    public let copyright: String
    public let artistId: String
    public let contentAdvisoryRating: String?
    public let artistUrl: String
    public let artworkUrl100: String
    public let genres: [AlbumGenre]
    public let url: String
    
}
