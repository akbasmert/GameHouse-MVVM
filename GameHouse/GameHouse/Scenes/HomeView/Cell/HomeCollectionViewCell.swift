//
//  HomeCollectionViewCell.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 14.07.2023.
//

import UIKit
import GameHouseAPI
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingReleasedLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static let reuseIdentifier = String(describing: HomeCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(game: Game) {
        DispatchQueue.main.async {
            self.setImage(game: game)
        }
        if let name = game.name {
            titleLabel.text = name
        } else {
            titleLabel.text = ""
        }
        
        if let rating = game.rating, let released = game.released {
            ratingReleasedLabel.text = "\(rating) - \(released)"
        } else {
            ratingReleasedLabel.text = ""
        }
    }
    
//    func setImage(game: Game) {
//        ImageDownloader.shared.image(news: game) { [weak self] data, error in
//            guard let self = self else { return }
//            if let data = data {
//                if let img = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.imageView?.image = img
//                    }
//                }
//            }
//        }
//    }
    func setImage(game: Game) {
        let fullPath = game.backgroundImage ?? ""
        
        if let url = URL(string: fullPath) {
            imageView.sd_setImage(with: url)
        }
     }
}
