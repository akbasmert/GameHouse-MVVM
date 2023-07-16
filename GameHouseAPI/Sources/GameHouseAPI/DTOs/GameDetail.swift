//
//  File.swift
//  
//
//  Created by Mert AKBAŞ on 15.07.2023.
//

import Foundation


public struct GameDetail: Decodable {
       public let id: Int?
       public let name, description: String?
       public let metacritic: Int?
       public let released: String?
       public let backgroundImage: String?
       public let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id, name
        case description, metacritic
        case released
        case backgroundImage = "background_image"
        case rating

    }
}
