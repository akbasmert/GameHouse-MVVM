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
}

extension SplashViewModel: SplashViewModelProtocol {
  
    func internetConnection() {
        if service.isConnectedToInternet() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.delegate?.toHomeViewController()
            }
        } else {
            self.delegate?.noInternetConnection()
        }
    }
}
