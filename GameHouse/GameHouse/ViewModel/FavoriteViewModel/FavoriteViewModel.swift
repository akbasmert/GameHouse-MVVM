//
//  FavoriteViewModel.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 16.07.2023.
//

import Foundation
import GameHouseAPI

protocol FavoriteViewModelProtocol {
    var  delegate: FavoriteViewModelDelegate? { get set }
    var numberOfItems: Int { get }
   
    
//    func fetchData()
    func checkGameData(gameId: Int)
    func saveFilteredGameVideos()
    func favoriteGame(_ index: Int) -> Game?
    func getVideoId(index: Int) -> Int
 
}

protocol FavoriteViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

final class FavoriteViewModel {
    
    static let shared = FavoriteViewModel(service: VideoGameService())
    let service: VideoGameServiceProtocol
    weak var delegate: FavoriteViewModelDelegate?
    
    private var videoGames: [Game] = []
    private var filteredVideoGames: [Game] = []
    
    init(service: VideoGameServiceProtocol) {
        self.service = service
    }
    
//    fileprivate func fetchGame() {
//        // TODO: Show loading indicator puan için önemli
//        // ViewControllarda loading gösterilmesini iste/haber ver
//        self.delegate?.showLoadingView()
//        service.fetchGameVideo { [weak self] response in
//            guard let self else { return }
//            // TODO: hide loading
//            // ViewControllarda loading gizlemesini iste/haber ver
//            self.delegate?.hideLoadingView()
//            switch response {
//            case .success(let gameVideos):
//
//                self.videoGames = gameVideos
//                DispatchQueue.main.async {
//                    self.saveFilteredGameVideos()
//                }
//               self.delegate?.reloadData()
//
//            case .failure(let error):
//                print("Mert: \(error)")
//            }
//        }
//    }
    
 
   
}

extension FavoriteViewModel: FavoriteViewModelProtocol {
  
  
    var numberOfItems: Int {
        return filteredVideoGames.count
    }
    
//    func fetchData() {
//        fetchGame()
//    }
    func getVideoId(index: Int) -> Int {
        return (filteredVideoGames[index].id ?? 0) 
    }
    
    func checkGameData(gameId: Int) {
        let audioData = CoreDataManager.shared.fetchAudioData()
        
        if audioData.contains(gameId) {
            CoreDataManager.shared.deleteAudioData(withTrackId: gameId)
        } else {
            CoreDataManager.shared.saveAudioData(Int64(gameId))
        }
    }
    
    func favoriteGame(_ index: Int) -> Game? {
        filteredVideoGames[index]
    }
    
    func saveFilteredGameVideos() {
        let idsToFilter = CoreDataManager.shared.fetchAudioData()
        
        filteredVideoGames = HomeViewModel.videoGames.filter { game in
           
            guard let gameId = game.id else {
                return false
            }
          //  print(HomeViewModel.videoGames.count)
            print(gameId)
            return idsToFilter.contains(gameId)
        }
        self.delegate?.reloadData()
        print("Filtrelenmiş liste: \(filteredVideoGames)")
    }

}
