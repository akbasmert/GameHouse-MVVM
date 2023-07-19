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
    
    func viewDidLoad()
    func filteredGame(key: String)
    func getGameDetailID(index: Int) -> Int
    func game(_ index: Int) -> Game?
    func filteredGame(_ index: Int) -> Game?
    func fetchData()
}

protocol HomeViewModelDelegate: AnyObject {
    
    func setupCollectionView()
    func setupSearchBar()
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
        self.delegate?.showLoadingView()
        service.fetchGameVideo { [weak self] response in
            guard let self else { return }
            self.delegate?.hideLoadingView()
            switch response {
            case .success(let gameVideos):
                videoGames = gameVideos
                DispatchQueue.main.async {
                              self.delegate?.reloadData()
                          }
            case .failure(let error):
                print("\(error)")
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
    
    func viewDidLoad() {
        self.fetchData()
        self.delegate?.setupCollectionView()
        self.delegate?.setupSearchBar()
    }
    
    func filteredGame(_ index: Int) -> Game? {
        filteredVideoGames[index]
    }
    
    func filteredGame(key: String) {
        guard key.count >= 3 else { return }
        filteredVideoGames = videoGames.filter { game in
            guard let gameName = game.name else { return false }
            return gameName.lowercased().contains(key.lowercased())
        }
    }
    
    func getGameDetailID(index: Int) -> Int {
        return videoGames[index].id ?? 111
    }
    
    func game(_ index: Int) -> Game? {
        videoGames[index + 3]
    }
    
    func fetchData() {
        fetchGame()
    }
}
