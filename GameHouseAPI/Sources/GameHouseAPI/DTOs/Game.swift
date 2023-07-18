//
//  Game.swift
//  
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import Foundation

public struct GameResult: Decodable {
   public let count: Int?
   public let next: String?
   public let results: [Game]?
   
    enum CodingKeys: String, CodingKey {
        case count, next, results
    }
}


public struct Game: Decodable {
   public let id: Int?
   public let name, released: String?
   public let backgroundImage: String?
   public let rating: Double?
  
    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
    }
}
