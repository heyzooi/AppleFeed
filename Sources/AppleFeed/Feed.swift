//
//  Feed.swift
//  
//
//  Created by Victor Hugo Carvalho Barros on 2019-10-26.
//

import Foundation

public struct Feed: Decodable {
    
    public let id: String
    public let title: String
    public let results: [Album]
    
}
