//
//  DetailViewModel.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 15.07.2023.
//
import Foundation
import GameHouseAPI
import SDWebImage

protocol DetailViewModelProtocol {
    
    var delegate: DetailViewModelDelegate?  { get set }
    var getTitle: String { get }
    var getReleaseDate: String { get }
    var getMetacritic: Int { get }
    var getDescription: String { get }
    var getImage: UIImage? { get }
    
    func fetchData(id: Int)
    func checkGameData(gameId: Int)
    func isSavedGameId(gameId: Int) -> Bool
}

protocol DetailViewModelDelegate: AnyObject {
    
    func showLoadingView()
    func hideLoadingView()
    func setTitle()
    func setReleaseDate()
    func setMetacritic()
    func setDescription()
    func setImage()
}

final class DetailViewModel {
    
    static let shared = DetailViewModel(service: VideoGameDetailService())
    let  service: VideoGameDetailServiceProtocol
    weak var delegate: DetailViewModelDelegate?
    private var detailGame: GameDetail?
  
    init(service: VideoGameDetailServiceProtocol) {
        self.service = service
    }
    
    fileprivate func fetchDetailGame(id: Int) {
        self.delegate?.showLoadingView()
        service.fetchGameDetailVideo(id: id) { [weak self] response in
            guard let self else { return }
            
            self.delegate?.hideLoadingView()
            switch response {
            case .success(let detailGame):

                self.detailGame = detailGame
                DispatchQueue.main.async {
                    self.delegate?.setTitle()
                    self.delegate?.setMetacritic()
                    self.delegate?.setDescription()
                    self.delegate?.setReleaseDate()
                    self.delegate?.setImage()
                }
               
            case .failure(let error):
                print("hata: \(error)")
            }
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol {

    func isSavedGameId(gameId: Int) -> Bool {
        let audioData = CoreDataManager.shared.fetchAudioData()
        return audioData.contains { $0.id == gameId }
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

    func fetchData(id: Int) {
        fetchDetailGame(id: id)
    }
    
    var getTitle: String {
        detailGame?.name ?? "No Title"
    }
    
    var getReleaseDate: String {
        detailGame?.released ?? ""
    }
    
    var getMetacritic: Int {
        detailGame?.metacritic ?? 1
    }
    
    var getDescription: String {
        detailGame?.description ?? "No Description"
    }
    
    var getImage: UIImage? {
        guard let imageURL = detailGame?.backgroundImage else {
              return nil
          }
        return SDImageCache.shared.imageFromDiskCache(forKey: imageURL)
    }
}
