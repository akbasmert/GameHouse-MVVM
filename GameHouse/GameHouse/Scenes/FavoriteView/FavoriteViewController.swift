//
//  FavoriteViewController.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 16.07.2023.
//

import UIKit

class FavoriteViewController: UIViewController, LoadingShowable {

    @IBOutlet weak var tableView: UITableView!
    
    var index: Int?
    var favoriteViewModel: FavoriteViewModelProtocol! {
        didSet {
            favoriteViewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteViewModel = FavoriteViewModel.shared
        favoriteViewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteViewModel.saveFilteredGameVideos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteToDetail" {
            let destinationDetailVC = segue.destination as! DetailViewController
            destinationDetailVC.gameDetailID = favoriteViewModel.getVideoId(index: index ?? 0 )
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoriteViewModel.numberOfItems == 0 {
            return 1
        } else {
            return favoriteViewModel.numberOfItems
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if favoriteViewModel.numberOfItems == 0 {
             let noDataCell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.reuseIdentifier) as! NoDataTableViewCell
            noDataCell.selectionStyle = .none
            
            return noDataCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier, for: indexPath) as! FavoriteTableViewCell
            cell.selectionStyle = .none
            if let game = self.favoriteViewModel.favoriteGame(indexPath.row) {
                cell.configure(game: game)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if favoriteViewModel.numberOfItems != 0 {
            self.index = indexPath.row
            performSegue(withIdentifier: "favoriteToDetail", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if favoriteViewModel.numberOfItems != 0 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            if favoriteViewModel.numberOfItems != 0 {
                favoriteViewModel.checkGameData(gameId: favoriteViewModel.getVideoId(index: indexPath.row))
                DispatchQueue.main.async {
                    self.favoriteViewModel.saveFilteredGameVideos()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if favoriteViewModel.numberOfItems != 0 {
            return 90
        } else {
            let height = tableView.bounds.size.height
            return height
        }
    }
}

extension FavoriteViewController: FavoriteViewModelDelegate {
    
    func setupTableView() {
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil),
                           forCellReuseIdentifier: NoDataTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
