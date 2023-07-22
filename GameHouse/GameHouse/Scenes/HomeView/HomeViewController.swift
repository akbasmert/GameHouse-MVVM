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
    
    private var isOnSplahView: Bool = true
    private var isFilteredList: Bool = false
    private var detailGameId: Int?
    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        homeViewModel = HomeViewModel.shared
        homeViewModel.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageTapped(notification:)), name: Notification.Name("ImageTapped"), object: nil)
        
        setAccessiblityIdentifiers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isOnSplahView {
            performSegue(withIdentifier: "toSplashScreen", sender: nil)
            isOnSplahView = false
        }
    }
    
    @objc private func handleImageTapped(notification: Notification) {
        guard let userInfo = notification.userInfo,
        let index = userInfo["index"] as? Int else { return }
        detailGameId = homeViewModel.getGameDetailID(index: index)
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
            if homeViewModel.filteredNumberOfItems == 0 {
                return 1
            } else {
                return homeViewModel.filteredNumberOfItems
            }
        } else {
            if section == 0 {
                return 1
            } else {
                return homeViewModel.numberOfItems - 3
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeCollectionViewCell else { fatalError("no cell") }
        guard let noDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: NoDataCollectionViewCell.reuseIdentifier, for: indexPath) as? NoDataCollectionViewCell else { fatalError("no cell") }
        
        if isFilteredList {
            if homeViewModel.filteredNumberOfItems == 0 {
                return noDataCell
            } else {
                if let game = self.homeViewModel.filteredGame(indexPath.row) {
                    homeCell.configure(game: game)
                }
                return homeCell
            }
        } else {
            if indexPath.section == 0 {
                guard let pageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PageViewCollectionViewCell.reuseIdentifier, for: indexPath) as? PageViewCollectionViewCell else { fatalError("no cell") }
                
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if isFilteredList {
            if homeViewModel.filteredNumberOfItems != 0 {
                detailGameId = homeViewModel.getGameDetailID(index: indexPath.row + 3)
                performSegue(withIdentifier: "toDetailVC", sender: nil)
            }
        } else {
            if indexPath.section == 0 {

            } else {
                detailGameId = homeViewModel.getGameDetailID(index: indexPath.row + 3)
                performSegue(withIdentifier: "toDetailVC", sender: nil)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.bounds.size.width
        let height = self.collectionView.bounds.size.height
        
        if isFilteredList {
            if homeViewModel.filteredNumberOfItems == 0 {
                return CGSize(width: width, height: height)
            } else {
                return CGSize(width: width, height: 90)
            }
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
        searchBar.resignFirstResponder() // Klavyeyi kapat
        searchBar.showsCancelButton = false
        isFilteredList = false
        searchBar.text = ""
        collectionView.reloadData()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Lütfen oyun adı giriniz."
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "PageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PageViewCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "NoDataCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: NoDataCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
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

extension HomeViewController {
    func setAccessiblityIdentifiers() {
        collectionView.accessibilityIdentifier = "collectionView"
        searchBar.accessibilityIdentifier = "searchBar"
    }
}
