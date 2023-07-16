//
//  DetailViewModel.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 15.07.2023.
//
import Foundation
import GameHouseAPI

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate?  { get set }
    
    func fetchData(id: Int)
}

protocol DetailViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    
}

final class DetailViewModel {
    
    static let shared = DetailViewModel(service: VideoGameDetailService())
    let  service: VideoGameDetailServiceProtocol
    weak var delegate: DetailViewModelDelegate?
    
  
    
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
                print("detayy: \(detailGame)")
            
            case .failure(let error):
                print("hatatatataa\(error)")
                
            }
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol {

    func fetchData(id: Int) {
        fetchDetailGame(id: id)
    }
}
