//
//  Response.swift
//  
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import Foundation

public struct GameResponse: Decodable {
    
    public let results: [Game]
    
    private enum RootCodingKeys: String, CodingKey {
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        self.results = try container.decode([Game].self, forKey: .results)
    }
}
