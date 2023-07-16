//
//  HomeViewModel.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import Foundation
import GameHouseAPI

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var videoGame: [Game] { get }
    var numberOfItems: Int { get }
    var filteredNumberOfItems: Int { get }
    
    func filteredGame(key: String)
    func getGameDetailID(index: Int) -> Int
    func game(_ index: Int) -> Game?
    func filteredGame(_ index: Int) -> Game?
    func fetchData()
    func saveGame()
}

protocol HomeViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

final class HomeViewModel: NSObject {
    
    static let shared = HomeViewModel(service: VideoGameService())
    
    let service: VideoGameServiceProtocol
    weak var delegate: HomeViewModelDelegate?
    private var videoGames: [Game] = []
    private var filteredVideoGames: [Game] = []
    
    init(service: VideoGameServiceProtocol) {
        self.service = service
    }
    
    fileprivate func fetchGame() {
        // TODO: Show loading indicator puan için önemli
        // ViewControllarda loading gösterilmesini iste/haber ver
        self.delegate?.showLoadingView()
        service.fetchGameVideo { [weak self] response in
            guard let self else { return }
            // TODO: hide loading
            // ViewControllarda loading gizlemesini iste/haber ver
            self.delegate?.hideLoadingView()
            switch response {
            case .success(let gameVideos):
                print("Mert: \(gameVideos)")
                self.videoGames = gameVideos
              
                // TODO: collectionview reload data
                // View Controllarda collectionview i güncelle.
               self.delegate?.reloadData()
            case .failure(let error):
                print("Mert: \(error)")
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {

    var filteredNumberOfItems: Int {
        filteredVideoGames.count
    }
    
    var numberOfItems: Int {
        videoGames.count
    }
    
    var videoGame: [Game] {
        videoGames
    }
    
    func filteredGame(_ index: Int) -> Game? {
        filteredVideoGames[index]
    }
    
    func filteredGame(key: String) {
        guard key.count >= 3 else {
            return
        }
        
        filteredVideoGames = videoGames.filter { game in
            guard let gameName = game.name else {
                return false
            }
            return gameName.lowercased().contains(key.lowercased())
        }
        
        print("filtreleme sonuc: \(filteredVideoGames)")
    }
    
    func getGameDetailID(index: Int) -> Int {
        return videoGames[index].id ?? 3498
    }
    
    func game(_ index: Int) -> Game? {
        videoGames[index + 3]
    }
    
    func saveGame() {
      //  let gameEntities = CoreDataManager.shared.fetchAudioData()
       
//        for gameEntity in gameEntities {
//            print("ID: \(gameEntity.id)")
//            print("Name: \(gameEntity.name ?? "")")
//
//            // Diğer özelliklere erişim...
//        }
    }
    
    func fetchData() {
        fetchGame()
    }
    
    
}
