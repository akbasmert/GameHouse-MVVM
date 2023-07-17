//
//  DetailService.swift
//  
//
//  Created by Mert AKBAŞ on 15.07.2023.
//

import Foundation

public protocol VideoGameDetailServiceProtocol: AnyObject {
    func fetchGameDetailVideo(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void)
}

public class VideoGameDetailService:VideoGameDetailServiceProtocol {
    public init() {}
    
    public func fetchGameDetailVideo(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {
        let urlString = "https://api.rawg.io/api/games/\(id)?key=9fa7e68855814284b5c121ef44850c20"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                    print("Hata alındı: \(error.localizedDescription)")
                } else {
                    completion(.failure(APIError.invalidData))
                    print("Veri alınamadı.")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let gameDetail = try decoder.decode(GameDetail.self, from: data)
                completion(.success(gameDetail))
            } catch {
                completion(.failure(error))
                print("JSON DECODE HATASI: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
        enum APIError: Error {
            case invalidData
        }
