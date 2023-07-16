//
//  DetailResponse.swift
//  
//
//  Created by Mert AKBAŞ on 15.07.2023.
//

import Foundation

public struct DetailResponse: Decodable {
    public let results: [GameDetail]

    private enum RootCodingKeys: String, CodingKey {
        case results
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        self.results = try container.decode([GameDetail].self, forKey: .results)
    }
}



