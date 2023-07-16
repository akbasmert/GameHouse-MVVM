//
//  Service.swift
//  
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import Foundation

public protocol VideoGameServiceProtocol: AnyObject {
    func isConnectedToInternet() -> Bool
    func fetchGameVideo(competion: @escaping (Result<[Game], Error>) -> Void)
}

public class VideoGameService: VideoGameServiceProtocol {
    
    public init() {}
    
    public func isConnectedToInternet() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    public func fetchGameVideo(competion: @escaping (Result<[Game], Error>) -> Void) {
         
        let urlString = "https://api.rawg.io/api/games?key=9fa7e68855814284b5c121ef44850c20"
                let decoder = Decoders.dateDecoder
        
                guard let url = URL(string: urlString) else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    do {
                        let response = try decoder.decode(GameResponse.self, from: data)
                        competion(.success(response.results))
                    } catch {
                        print("********JSON DECODE ERROR**********")
                    }
                }
                task.resume()
    }
}
