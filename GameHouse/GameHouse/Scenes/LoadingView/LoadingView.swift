//
//  LoadingView.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import UIKit

class LoadingView {
    var timer: Bool = false
    var acrivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    static let shared = LoadingView()
    var blurView: UIVisualEffectView = UIVisualEffectView()
    
    private init() {
        configure()
    }
    
    func configure() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIWindow(frame: UIScreen.main.bounds).frame
        acrivityIndicator.center = blurView.center
        acrivityIndicator.hidesWhenStopped = true
        acrivityIndicator.style = .large
      
        blurView.contentView.addSubview(acrivityIndicator)
    }
    
    func startLoading() {
        UIApplication.shared.windows.first?.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        acrivityIndicator.startAnimating()
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.blurView.removeFromSuperview()
            self.acrivityIndicator.stopAnimating()
        }
    }
}
