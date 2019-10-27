//
//  AppleFeed.swift
//  
//
//  Created by Victor Hugo Carvalho Barros on 2019-10-26.
//

import Foundation
import Combine

public enum APIVersion: String {
    
    case v1
    
}

public enum Country: String {

    case unitedStates = "us"
    case canada = "ca"
    
    //TODO: add more options later

}

public enum MediaType: String {

    case appleMusic = "apple-music"
    case itunesMusic = "itunes-music"
    
    //TODO: add more options later

}

public enum FeedType: String {

    case topAlbums = "top-albums"
    case topSongs = "top-songs"
    
    //TODO: add more options later

}

public enum Genre: String {
    
    case all
    
}

public struct AppleFeedError: Error {
    
    public let error: String
    
}

#if canImport(UIKit)
import UIKit
public typealias Image = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias Image = NSImage
#endif

public class AppleFeed {

    public static let shared = AppleFeed()
    
    public func fetchFeed(
        apiVersion: APIVersion = .v1,
        country: Country,
        mediaType: MediaType,
        feedType: FeedType,
        genre: Genre = .all,
        resultsLimit: UInt = 100,
        explicit: Bool = true
    ) -> AnyPublisher<FeedResult, Error> {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/\(apiVersion.rawValue)/\(country.rawValue)/\(mediaType.rawValue)/\(feedType.rawValue)/\(genre.rawValue)/\(resultsLimit)/\(explicit ? "explicit" : "non-explicit").json") else {
            return Fail(error: AppleFeedError(error: "Invalid URL")).eraseToAnyPublisher()
        }
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(3)
            .tryMap {
                guard let httpResponse = $0.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw AppleFeedError(error: "Invalid Response")
                }
                return $0.data
            }
            .decode(type: FeedResult.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public func fetchImage(url: URL) -> AnyPublisher<Image, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(3)
            .tryMap {
                guard let httpResponse = $0.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw AppleFeedError(error: "Invalid Response")
                }
                guard let image = Image(data: $0.data) else {
                    throw AppleFeedError(error: "Invalid Image")
                }
                return image
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
