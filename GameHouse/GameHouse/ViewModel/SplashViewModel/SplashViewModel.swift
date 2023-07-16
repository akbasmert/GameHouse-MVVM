//
//  SplashViewModel.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import Foundation
import GameHouseAPI

protocol SplashViewModelProtocol {
    var delegate: SplashViewModelDelegate? { get set }
    
    func fetchData()
    func internetConnection()
}

protocol SplashViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func noInternetConnection()
    func toHomeViewController()
}

final class SplashViewModel {
    
    static let shared = SplashViewModel(service: VideoGameService())
    
    let service: VideoGameServiceProtocol
    weak var delegate: SplashViewModelDelegate?
    private var videoGame: [Game] = []
    
    init(service: VideoGameServiceProtocol) {
        self.service = service
    }
    
//    func checkInternetConnection() {
//        let internetStatus = service.isConnectedToInternet()
//
//    }
    
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
            case .success(let movies):
               // print("Mert: \(movies)")
                for game in movies {
                    CoreDataManager.shared.saveAudioData(game)
                }
                
               //videoGame = CoreDataManager.shared.fetchAudioData()
               
//                self.movies = movies
               
                // TODO: collectionview reload data
                // View Controllarda collectionview i güncelle.
//                self.delegate?.reloadData()
            case .failure(let error):
                print("Mert: \(error)")
            }
        }
    }
}

extension SplashViewModel: SplashViewModelProtocol {
    func fetchData() {
        fetchGame()
    }
    
    
    func internetConnection() {
        if service.isConnectedToInternet() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              //  self.router.navigate(.homeScreen)
                self.delegate?.toHomeViewController()
            }
            
           
        } else {
          //  view.noInternetConnection()
            self.delegate?.noInternetConnection()
        }
    }
    

}
