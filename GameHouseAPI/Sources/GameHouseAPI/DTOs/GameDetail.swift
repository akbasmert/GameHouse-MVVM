//
//  File.swift
//  
//
//  Created by Mert AKBAŞ on 15.07.2023.
//

import Foundation

public struct GameDetail: Decodable {
    public let id: Int?
    public let slug: String?
    public let name, released: String?
    public let nameOriginal: String?
    public let description: String?
    public let metacritic: Int?
    public let rating: Double?
    public let backgroundImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name, released
        case rating
        case nameOriginal = "name_original"
        case description = "description_raw"
        case backgroundImage = "background_image"
        case metacritic
    }
}
