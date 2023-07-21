//
//  DetailViewController.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 15.07.2023.
//

import UIKit

class DetailViewController: UIViewController, LoadingShowable {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailReleaseDate: UILabel!
    @IBOutlet weak var detailMetacritic: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    
    var gameDetailID: Int?
    var isFavorite: Bool = false
    var detailViewModel: DetailViewModelProtocol! {
        didSet {
            detailViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailViewModel = DetailViewModel.shared
        detailViewModel.fetchData(id: gameDetailID ?? 2454)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: getFavoriteImage(),
                                                            style: .plain, target: self,
                                                            action: #selector(favoriteButtonTapped))
        setAccessiblityIdentifiers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setRightBarButtonItemImage(isFavorite: detailViewModel.isSavedGameId(gameId: gameDetailID ?? 1))
    }
    
    @objc func favoriteButtonTapped() {
         isFavorite.toggle()
         navigationItem.rightBarButtonItem?.image = getFavoriteImage()
        detailViewModel.checkGameData(gameId: gameDetailID ?? 1)
     }
     
     func getFavoriteImage() -> UIImage? {
         let heartImageName = isFavorite ? "heart.fill" : "heart"
         return UIImage(systemName: heartImageName)
     }
    
    func setRightBarButtonItemImage(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        self.isFavorite = isFavorite ? true : false
        let image = UIImage(systemName: imageName)
        navigationItem.rightBarButtonItem?.image = image
    }
}

extension DetailViewController: DetailViewModelDelegate {
    
    func setImage() {
        detailImageView.image = detailViewModel.getImage
    }
    
    func setReleaseDate() {
        detailReleaseDate.text = detailViewModel.getReleaseDate
    }
    
    func setMetacritic() {
        detailMetacritic.text = "\(detailViewModel.getMetacritic)"
    }
    
    func setDescription() {
        detailDescription.text = detailViewModel.getDescription
    }

    func setTitle() {
        detailTitle.text = detailViewModel.getTitle
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
}

extension DetailViewController {
    func setAccessiblityIdentifiers() {
        detailImageView.accessibilityIdentifier = "detailImageView"
        detailTitle.accessibilityIdentifier = "detailTitle"
        detailReleaseDate.accessibilityIdentifier = "detailReleaseDate"
        detailMetacritic.accessibilityIdentifier = "detailMetacritic"
        detailDescription.accessibilityIdentifier = "detailDescription"
    }
}
