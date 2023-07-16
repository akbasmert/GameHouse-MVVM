//
//  SplashViewController.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 14.07.2023.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
 //   func noInternetConecction()
}

class SplashViewController: BaseViewController {

    var splashViewModel: SplashViewModelProtocol! {
        didSet {
            splashViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashViewModel = SplashViewModel.shared
        // Do any additional setup after loading the view.
        splashViewModel.internetConnection()
        splashViewModel.fetchData()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == "toHomeVC" {
//////            let destinationDetailVC = segue.destination as! HomeViewController
//////            destinationDetailVC.homeViewModel  = HomeViewModel.shared
////        }
//        if segue.identifier == "toHomeVC" {
//            if let destinationDetailVC = segue.destination as? HomeViewController {
//                destinationDetailVC.homeViewModel = HomeViewModel.shared
//            }
//        }
//    }
}

extension SplashViewController: SplashViewModelDelegate {
    func toHomeViewController() {
      //  performSegue(withIdentifier: "toHomeVC", sender: nil)
        dismiss(animated: false)
    }
    
    func noInternetConnection() {
        DispatchQueue.main.async {
            self.showAlert("Error", "No internet")
        }
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
}

extension SplashViewController: SplashViewControllerProtocol {
  
}
