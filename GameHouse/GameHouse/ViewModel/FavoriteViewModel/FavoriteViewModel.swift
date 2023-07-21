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
   
    func checkGameData(gameId: Int)
    func saveFilteredGameVideos()
    func favoriteGame(_ index: Int) -> GameEntity?
    func getVideoId(index: Int) -> Int
    func viewDidLoad()
}

protocol FavoriteViewModelDelegate: AnyObject {
    
    func setupTableView()
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

final class FavoriteViewModel {
    
    static let shared = FavoriteViewModel(service: VideoGameService())
    let service: VideoGameServiceProtocol
    weak var delegate: FavoriteViewModelDelegate?
    
    private var gameList: [GameEntity] = []
    private var filteredVideoGames: [Game] = []
    private var detailGame: GameDetail?
    
    init(service: VideoGameServiceProtocol) {
        self.service = service
    }
}

extension FavoriteViewModel: FavoriteViewModelProtocol {
  
    var numberOfItems: Int {
        return gameList.count
    }
    
    func viewDidLoad() {
        delegate?.setupTableView()
    }
    
    func getVideoId(index: Int) -> Int {
        return Int((gameList[index].id ))
    }
    
    func checkGameData(gameId: Int) {
        let gameEntities = CoreDataManager.shared.fetchAudioData()
        let existingGameEntity = gameEntities.first { $0.id == Int64(gameId) }
        
        if let existingGameEntity = existingGameEntity {
            CoreDataManager.shared.deleteAudioData(withID: Int(existingGameEntity.id))
        } else {
            guard let game =  detailGame else { return  }
            CoreDataManager.shared.saveAudioData(game)
        }
    }
    
    func favoriteGame(_ index: Int) -> GameEntity? {
        gameList[index]
    }
    
    func saveFilteredGameVideos() {
        gameList.removeAll()
        gameList = CoreDataManager.shared.fetchAudioData()
        self.delegate?.reloadData()
    }
}
