//
//  DetailViewController.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 15.07.2023.
//

import UIKit

class DetailViewController: UIViewController, LoadingShowable {

    var gameDetailID: Int?
    var detailViewModel: DetailViewModelProtocol! {
        didSet {
            detailViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailViewModel = DetailViewModel.shared
        detailViewModel.fetchData(id: 3498)
        print(gameDetailID)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

extension DetailViewController: DetailViewModelDelegate {
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
}
