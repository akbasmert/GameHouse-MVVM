//
//  FavoriteTableViewCell.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 16.07.2023.
//

import UIKit
import GameHouseAPI

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    static let reuseIdentifier = String(describing: FavoriteTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
            ratingLabel.text = "\(rating) - \(released)"
        } else {
            ratingLabel.text = ""
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
            favoriteImageView.sd_setImage(with: url)
        }
     }
    
}
