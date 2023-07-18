//
//  PageViewCollectionViewCell.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 14.07.2023.
//

import UIKit
import GameHouseAPI
import SDWebImage

class PageViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    static let reuseIdentifier = String(describing: PageViewCollectionViewCell.self)
    private var currentPage = 0
    var images: [String] = []
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pageController.addTarget(self, action: #selector(pageChange(_:)), for: .valueChanged)
        scrollView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
          scrollView.addGestureRecognizer(tapGesture)
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
      }
      
      @objc private func scrollToNextImage() {
          currentPage += 1
          if currentPage >= images.count {
              currentPage = 0
          }
          let offsetX = CGFloat(currentPage) * scrollView.frame.size.width
          scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
      }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
          let location = gestureRecognizer.location(in: scrollView)
          let tappedPageIndex = Int(location.x / scrollView.bounds.width)
        
          let userInfo: [AnyHashable: Any] = [ "index": tappedPageIndex ]
        
          NotificationCenter.default.post(name: Notification.Name("ImageTapped"), object: nil, userInfo: userInfo)
      }

    @objc private func pageChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * scrollView.frame.size.width, y: 0), animated: true)
    }
    
    func configure(game: [Game]) {
        for i in 0..<3 {
            if i < game.count {
                if let backgroundImage = game[i].backgroundImage {
                    images.append(backgroundImage)
                    if i == 2 {
                        changeScrollView()
                    }
                }
            }
        }
    }
    
    private func changeScrollView() {
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(images.count), height: scrollView.bounds.height)
        scrollView.isPagingEnabled = true

        for i in 0..<images.count {
            let page = UIView(frame: CGRect(x: CGFloat(i) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
            scrollView.addSubview(page)

            let image = UIImageView(frame: CGRect(x: CGFloat(i) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
          

            if let imageURL = URL(string: images[i]) {
                image.sd_setImage(with: imageURL)
            }

            image.contentMode = .scaleToFill
            image.layer.cornerRadius = 8.0 // Köşe yuvarlatma uygulama
                   image.clipsToBounds = true
            scrollView.addSubview(image)
        }
    }
}

extension PageViewCollectionViewCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let currentIndex = Int(floor(scrollView.contentOffset.x / scrollView.frame.size.width))
          let maxIndex = min(images.count - 1, 2)
          
          if currentIndex < 0 {
              scrollView.contentOffset.x = 0
          } else if currentIndex > maxIndex {
              scrollView.contentOffset.x = CGFloat(maxIndex) * scrollView.frame.size.width
          } else if currentIndex == 2 && scrollView.contentOffset.x > CGFloat(currentIndex) * scrollView.frame.size.width {
              scrollView.contentOffset.x = CGFloat(maxIndex) * scrollView.frame.size.width
          }
          pageController.currentPage = Int(floor(scrollView.contentOffset.x / scrollView.frame.size.width))
      }
}
