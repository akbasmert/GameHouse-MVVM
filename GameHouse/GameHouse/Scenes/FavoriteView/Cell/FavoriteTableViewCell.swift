//
//  FavoriteTableViewCell.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 16.07.2023.
//

import UIKit
import GameHouseAPI
import SDWebImage

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
    
    func configure(game: GameEntity) {
        DispatchQueue.main.async {
            self.setImage(game: game)
        }
        
        guard let name = game.name else {
            return titleLabel.text = ""
        }
        
        titleLabel.text = name
        
        guard let released = game.released else {
            return ratingLabel.text = "\(game.rating) - Not Released"
        }
        ratingLabel.text = "\(game.rating) - \(released)"
    }

    func setImage(game: GameEntity) {
        let fullPath = game.backgroundImage ?? ""
        
        if let url = URL(string: fullPath) {
            favoriteImageView.sd_setImage(with: url)
        }
     }
}
