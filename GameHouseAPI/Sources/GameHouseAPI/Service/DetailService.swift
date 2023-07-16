//
//  DetailService.swift
//  
//
//  Created by Mert AKBAŞ on 15.07.2023.
//

import Foundation

public protocol VideoGameDetailServiceProtocol: AnyObject {
    func isConnectedToInternet() -> Bool
    func fetchGameDetailVideo(id: Int, completion: @escaping (Result<[GameDetail], Error>) -> Void)
}

public class VideoGameDetailService: VideoGameDetailServiceProtocol {

    public init() {}

    public func isConnectedToInternet() -> Bool {
        return Reachability.isConnectedToNetwork()
    }

    public func fetchGameDetailVideo(id: Int, completion: @escaping (Result<[GameDetail], Error>) -> Void) {

        let urlString = "https://api.rawg.io/api/games/\(id)?key=9fa7e68855814284b5c121ef44850c20"
                let decoder = Decoders.dateDecoder

                guard let url = URL(string: urlString) else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    do {
                        let response = try decoder.decode(DetailResponse.self, from: data)
                        completion(.success(response.results))
                    } catch (let error) {
                        completion(.failure(error))
                        print("********JSON DECODE ERROR**********\(error.localizedDescription)")
                    }
                }
                task.resume()
    }
}

