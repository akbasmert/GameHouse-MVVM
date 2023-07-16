//
//  HomeViewController.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import UIKit

class HomeViewController: UIViewController, LoadingShowable {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isOnSplahView: Bool = true
    var isFilteredList: Bool = false
    var detailGameId: Int?
    
    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        homeViewModel = HomeViewModel.shared
        homeViewModel.fetchData()
        let layout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "PageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PageViewCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageTapped(notification:)), name: Notification.Name("ImageTapped"), object: nil)
     


       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      
          //  self.homeViewModel.fetchData()
     //   print(CoreDataManager.shared.fetchAudioData())
//        let gameEntities = CoreDataManager.shared.fetchAudioData()
//
//        for gameEntity in gameEntities {
//            print("ID: \(gameEntity.id)")
//            print("Name: \(gameEntity.name ?? "")")
//            // Diğer özelliklere erişim...
//        }

        navigationController?.setNavigationBarHidden(true, animated: false)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isOnSplahView {
            performSegue(withIdentifier: "toSplashScreen", sender: nil)
            isOnSplahView = false
        }
       
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        print( "tıklandı")
      //  homeViewModel = HomeViewModel.shared
        homeViewModel.saveGame()
        print(homeViewModel.videoGame)
        performSegue(withIdentifier: "toSplashScreen", sender: nil)
    }
    
    @objc private func handleImageTapped(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let index = userInfo["index"] as? Int else {
            return
        }
        print("glelen indez: \(index)")
       
        detailGameId = homeViewModel.getGameDetailID(index: index)
        // İşlem yapmak için index değerini kullanın
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationDetailVC = segue.destination as! DetailViewController
            destinationDetailVC.gameDetailID = detailGameId
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isFilteredList ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFilteredList {
            return homeViewModel.filteredNumberOfItems
        } else {
            if section == 0 {
                return 1
            } else {
                return homeViewModel.numberOfItems - 3
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeCollectionViewCell else {
            fatalError("no cell")
        }
        
        if isFilteredList {
            if let game = self.homeViewModel.filteredGame(indexPath.row) {
                homeCell.configure(game: game)
            }
            return homeCell
            
        } else {
            if indexPath.section == 0 {
                guard let pageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PageViewCollectionViewCell.reuseIdentifier, for: indexPath) as? PageViewCollectionViewCell else {
                    fatalError("no cell")
                }
                
                let pageViewGame = homeViewModel.videoGame
                pageViewCell.configure(game: pageViewGame)
                
                
                return pageViewCell
            } else {
              
                
                if let game = self.homeViewModel.game(indexPath.row) {
                    homeCell.configure(game: game)
                }
                
                return homeCell
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if isFilteredList {
//            detailGameId = homeViewModel.getGameDetailID(index: indexPath.row)
//            performSegue(withIdentifier: "toDetailVC", sender: nil)
//        } else {
//            if indexPath.section == 0 {
//
//            } else {
//                detailGameId = homeViewModel.getGameDetailID(index: indexPath.row)
//                performSegue(withIdentifier: "toDetailVC", sender: nil)
//            }
//        }
//
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFilteredList || indexPath.section != 0 {
            detailGameId = homeViewModel.getGameDetailID(index: indexPath.row)
            performSegue(withIdentifier: "toDetailVC", sender: nil)
        }
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.bounds.size.width
        
        if isFilteredList {
            return CGSize(width: width, height: 90)
        } else {
            if indexPath.section == 0 {
                return CGSize(width: width, height: width * 0.7)
            }
            return CGSize(width: width, height: 90)
        }
       
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
      print("mert")
        searchBar.showsCancelButton = true
        
        if searchText.count >= 3 {
            isFilteredList = true
            homeViewModel.filteredGame(key: searchText)
            collectionView.reloadData()
        } else {
            isFilteredList = false
            collectionView.reloadData()
        }
       
      
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("tıklandı")
        searchBar.resignFirstResponder() // Klavyeyi kapat
        searchBar.showsCancelButton = false
        isFilteredList = false
        searchBar.text = ""
        collectionView.reloadData()
    }

}

extension HomeViewController: HomeViewModelDelegate {
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    

    
    
    
}